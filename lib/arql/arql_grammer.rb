class Arql::Parser

options no_result_var

prechigh
  left  AND
  left  OR
preclow

token AND OR IDENTIFIER EQUAL

rule
  # this is the starting rule
  target
  : conditions                              { Query.new(:condition => val[0]) }
  ;

  conditions
  : conditions AND conditions                { Query::And.new(val[0], val[2]) } 
  | conditions OR conditions                 { Query::Or.new(val[0], val[2]) } 
  | condition
  ;
  
  operator
  : EQUAL                                   { '=' }
  ;

  identifier
  : IDENTIFIER                              { val[0] }
  ;

  condition
  : identifier operator identifier          { Query::Condition.new(val[0], val[1], val[2]) }
  ;
end

----- header ----
require 'strscan'

---- inner ----

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

def parse_arql(str)
  @input = str
  tokens = []
  str = "" if str.nil?
  scanner = StringScanner.new(str + ' ')

  until scanner.eos?
    case
    when scanner.scan(/\s+/)
      # ignore space
    when m = scanner.scan(/=/i)
      tokens.push [:EQUAL, m]
    when m = scanner.scan(/and\b/i)
      tokens.push   [:AND, m]
    when m = scanner.scan(/or\b/i)
      tokens.push   [:OR, m]
    when m = scanner.scan(/'(((\\')|[^'])*)'/) # single quoted
      tokens.push   [:IDENTIFIER, unescape_quote(unquote(m))]
    when m = scanner.scan(/"(((\\")|[^"])*)"/) # double quoted
      tokens.push   [:IDENTIFIER, unescape_quote(unquote(m))]
    when m = scanner.scan(/[\w-]+/)
      tokens.push   [:IDENTIFIER, unescape_quote(unquote(m))]
    # when m = scanner.scan(/((\d+\.?\d*)|(\d*\.?\d+))/)
    #   tokens.push   [:IDENTIFIER, m]
    when m = scanner.scan(/(\\"|\\'|[\w-])+/) # start with escaped quate
      tokens.push   [:IDENTIFIER, unescape_quote(m)]
    else
      raise "unexpected characters #{scanner.peek(5)}"
    end
  end
  tokens.push [false, false]
  yyparse(tokens, :each)
end
