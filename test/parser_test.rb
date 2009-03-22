require File.join(File.dirname(__FILE__), '/test_helper.rb')

class ParserTest < Test::Unit::TestCase

  class User < ActiveRecord::Base
  end

  def setup
    define_schema do
      create_table :users do |t|
        t.column :name, :string
      end
    end
    @parser = Arql::Parser.new
  end

  def test_parse_identifier
    assert_equal({:conditions => 'name = "kuli"'}, @parser.parse_arql(User, 'name = kuli').find_options)
  end

  def test_parse_identifier_quated_by_double_quate
    assert_equal({:conditions => 'name = "kuli"'}, @parser.parse_arql(User, 'name = "kuli"').find_options)
  end

  def test_parse_identifier_quated_by_single_quate
    assert_equal({:conditions => 'name = "kuli"'}, @parser.parse_arql(User, 'name = \'kuli\'').find_options)
  end

  def test_parse_identifier_quated_by_double_quate_including_escaped_double_quate
    assert_equal({:conditions => "name = \"ku\\\"li\""}, @parser.parse_arql(User, 'name = "ku\"li"').find_options)
  end

  def test_parse_identifier_quated_by_single_quate_including_escaped_single_quate
    assert_equal({:conditions => "name = \"ku'li\""}, @parser.parse_arql(User, "name = 'ku\\'li'").find_options)
  end

  def test_parse_identifier_starts_with_escaped_quate
    assert_equal({:conditions => 'name = "\'kuli"'}, @parser.parse_arql(User, "name = \\'kuli").find_options)
    assert_equal({:conditions => 'name = "\\"kuli"'}, @parser.parse_arql(User, "name = \\\"kuli").find_options)
  end

  def test_parse_number
    assert_equal({:conditions => 'id = 2'}, @parser.parse_arql(User, 'id = 2').find_options)
  end

  def test_less_than_operator
    assert_equal({:conditions => 'id < 2'}, @parser.parse_arql(User, 'id < 2').find_options)
  end

  def test_more_than_operator
    assert_equal({:conditions => 'id > 1'}, @parser.parse_arql(User, 'id > 1').find_options)
  end
end
