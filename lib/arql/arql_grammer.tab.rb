#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.5
# from Racc grammer file "".
#

require 'racc/parser.rb'

require 'strscan'

module Arql
  class Parser < Racc::Parser

module_eval(<<'...end arql_grammer.rb/module_eval...', 'arql_grammer.rb', 45)

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
...end arql_grammer.rb/module_eval...
##### State transition tables begin ###

racc_action_table = [
     9,    10,    12,     8,     2,     6,    13,     2,     2,     9 ]

racc_action_check = [
     4,     4,     7,     3,     0,     1,     8,     9,    10,    15 ]

racc_action_pointer = [
     0,     0,   nil,     3,    -2,   nil,   nil,    -2,     6,     3,
     4,   nil,   nil,   nil,   nil,     7 ]

racc_action_default = [
    -9,    -9,    -7,    -9,    -1,    -4,    -5,    -9,    -9,    -9,
    -9,    -8,    -6,    16,    -2,    -3 ]

racc_goto_table = [
     4,     7,     3,    11,   nil,   nil,   nil,   nil,   nil,    14,
    15 ]

racc_goto_check = [
     2,     4,     1,     5,   nil,   nil,   nil,   nil,   nil,     2,
     2 ]

racc_goto_pointer = [
   nil,     2,     0,   nil,     0,    -4,   nil ]

racc_goto_default = [
   nil,   nil,   nil,     5,   nil,   nil,     1 ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 7, :_reduce_1,
  3, 8, :_reduce_2,
  3, 8, :_reduce_3,
  1, 8, :_reduce_none,
  1, 10, :_reduce_5,
  1, 11, :_reduce_6,
  1, 12, :_reduce_7,
  3, 9, :_reduce_8 ]

racc_reduce_n = 9

racc_shift_n = 16

racc_token_table = {
  false => 0,
  :error => 1,
  :AND => 2,
  :OR => 3,
  :IDENTIFIER => 4,
  :EQUAL => 5 }

racc_nt_base = 6

racc_use_result_var = false

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "AND",
  "OR",
  "IDENTIFIER",
  "EQUAL",
  "$start",
  "target",
  "conditions",
  "condition",
  "operator",
  "identifier",
  "column" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'arql_grammer.rb', 14)
  def _reduce_1(val, _values)
     Query.new(:condition => val[0], :joins => @joins.collect(&:joins).flatten.compact) 
  end
.,.,

module_eval(<<'.,.,', 'arql_grammer.rb', 18)
  def _reduce_2(val, _values)
     Query::And.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'arql_grammer.rb', 19)
  def _reduce_3(val, _values)
     Query::Or.new(val[0], val[2]) 
  end
.,.,

# reduce 4 omitted

module_eval(<<'.,.,', 'arql_grammer.rb', 24)
  def _reduce_5(val, _values)
     '=' 
  end
.,.,

module_eval(<<'.,.,', 'arql_grammer.rb', 28)
  def _reduce_6(val, _values)
     val[0] 
  end
.,.,

module_eval(<<'.,.,', 'arql_grammer.rb', 32)
  def _reduce_7(val, _values)
     returning(Query::Column.create(@model, val[0])) {|column| @joins << column} 
  end
.,.,

module_eval(<<'.,.,', 'arql_grammer.rb', 36)
  def _reduce_8(val, _values)
     Query::Condition.new(val[0], val[1], val[2]) 
  end
.,.,

def _reduce_none(val, _values)
  val[0]
end

  end   # class Parser
  end   # module Arql