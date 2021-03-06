class Arql::Parser

options no_result_var

prechigh
  right ORDER_BY
  left  AND
  left  OR
  left  EQUAL
  left  UNEQUAL
  left  COMPARE_OP
preclow

token AND OR IDENTIFIER EQUAL UNEQUAL COMPARE_OP NIL ORDER_BY COMMA

rule
  # this is the starting rule
  target
  : opt_conditions opt_order_by             { Query::Base.new(:condition => val[0], :joins => @joins, :order_by => val[1]) }
  ;

  opt_conditions
  : /* optional */
  | conditions
  ;

  opt_order_by
  : /* optional */
  | order_by
  ;

  order_by
  : ORDER_BY columns                        { val[1] }
  ;

  columns
  : column                                  { [val[0]] }
  | column COMMA columns                    { [val[0]] + val[2] }
  ;

  conditions
  : conditions AND conditions               { Query::And.instance.expression(val[0], val[2]) }
  | conditions OR conditions                { Query::Or.instance.expression(val[0], val[2]) }
  | condition
  ;

  identifier
  : IDENTIFIER                              { val[0] }
  | NIL                                     { val[0] }
  ;

  column
  : IDENTIFIER                              { returning(Query::Column.new(@model, val[0])) {|column| @joins << column} }
  ;

  operator
  : EQUAL                                   { Query::Equal.instance }
  | UNEQUAL                                 { Query::Unequal.instance }
  | COMPARE_OP                              { Query::Operator.new(val[0]) }
  ;

  condition
  : column operator identifier              { val[1].expression(val[0], val[2]) }
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
    when m = scanner.scan(/<\=|>\=|>|</)
      tokens.push [:COMPARE_OP, m]
    when m = scanner.scan(/\!\=/)
      tokens.push [:UNEQUAL, m]
    when m = scanner.scan(/\=/)
      tokens.push [:EQUAL, m]
    when m = scanner.scan(/,/)
      tokens.push [:COMMA, m]
    when m = scanner.scan(/and\b/i)
      tokens.push   [:AND, m]
    when m = scanner.scan(/or\b/i)
      tokens.push   [:OR, m]
    when m = scanner.scan(/true\b/i)
      tokens.push   [:IDENTIFIER, true]
    when m = scanner.scan(/false\b/i)
      tokens.push   [:IDENTIFIER, false]
    when m = scanner.scan(/nil\b/i)
      tokens.push   [:NIL, nil]
    when m = scanner.scan(/order\s+by\b/i)
      tokens.push   [:ORDER_BY, m]
    when m = scanner.scan(/'(((\\')|[^'])*)'/)                  # single quoted
      tokens.push   [:IDENTIFIER, unescape_quote(unquote(m))]
    when m = scanner.scan(/"(((\\")|[^"])*)"/)                  # double quoted
      tokens.push   [:IDENTIFIER, unescape_quote(unquote(m))]
    when m = scanner.scan(/\d*\.\d+/)                           # floats
      tokens.push   [:IDENTIFIER, m.to_f]
    when m = scanner.scan(/\d+\.?/)                             # integers
      tokens.push   [:IDENTIFIER, m.to_i]
    when m = scanner.scan(/([^\b\s,\!\=<>]+)/)
      tokens.push   [:IDENTIFIER, m]
    else
      raise "unexpected characters #{scanner.peek(5)}"
    end
  end
  tokens.push [false, false]
  yyparse(tokens, :each)
end
