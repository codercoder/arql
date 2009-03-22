class Arql::Parser

options no_result_var

prechigh
  left  AND
  left  OR
preclow

token AND OR IDENTIFIER OPERATOR

rule
  # this is the starting rule
  target
  : conditions                               { Query.new(:condition => val[0], :joins => @joins.collect(&:joins).flatten.compact) }
  ;

  conditions
  : conditions AND conditions                { Query::And.new(val[0], val[2]) } 
  | conditions OR conditions                 { Query::Or.new(val[0], val[2]) } 
  | condition
  ;

  identifier
  : IDENTIFIER                              { val[0] }
  ;

  column
  : IDENTIFIER                              { returning(Query::Column.create(@model, val[0])) {|column| @joins << column} }
  ;

  condition
  : column OPERATOR identifier              { Query::Condition.new(val[0], val[1], val[2]) }
  ;
end

----- header ----
require 'strscan'

---- inner ----
OPERATORS = %w[= < >]

def unquote(value)
  case value
  when /^'(.*)'$/ then $1
  when /^"(.*)"$/ then $1
  else value
  end
end

def unescape_quote(value)
  value.gsub(/\\(['|"])/, '\1')
end

def parse_arql(model, str)
  @model = model
  @input = str
  @joins = []
  tokens = []
  str = "" if str.nil?
  scanner = StringScanner.new(str + ' ')

  until scanner.eos?
    case
    when scanner.scan(/\s+/)
      # ignore space
    when m = scanner.scan(/#{OPERATORS.join('|')}/i)
      tokens.push [:OPERATOR, m]
    when m = scanner.scan(/and\b/i)
      tokens.push   [:AND, m]
    when m = scanner.scan(/or\b/i)
      tokens.push   [:OR, m]
    when m = scanner.scan(/'(((\\')|[^'])*)'/)                  # single quoted
      tokens.push   [:IDENTIFIER, unescape_quote(unquote(m))]
    when m = scanner.scan(/"(((\\")|[^"])*)"/)                  # double quoted
      tokens.push   [:IDENTIFIER, unescape_quote(unquote(m))]
    when m = scanner.scan(/\d*\.\d+/)                           # floats
      tokens.push   [:IDENTIFIER, m.to_f]
    when m = scanner.scan(/\d+\.?/)                             # integers
      tokens.push   [:IDENTIFIER, m.to_i]
    when m = scanner.scan(/([\w-]|'|"|\\)+/)
      tokens.push   [:IDENTIFIER, m]
    else
      raise "unexpected characters #{scanner.peek(5)}"
    end
  end
  tokens.push [false, false]
  yyparse(tokens, :each)
end
