require 'test_helper'

class TestRpr < Minitest::Test
  def test_find_formatter
    f = Rpr.find_formatter('pry')
    assert { f.is_a? Module }
    assert { f.respond_to? :print }
  end

  def test_find_parser
    f = Rpr.find_parser('sexp')
    assert { f.is_a? Module }
    assert { f.respond_to? :parse }
  end

  def test_parse_args_when_args_is_empty
    opt = Rpr.parse_args([])
    assert { opt[:formatter].is_a? Symbol }
    assert { opt[:version] == false }
    assert { opt[:parser].is_a? Symbol }
    assert { opt[:expression].nil? }
  end

  def test_parse_args_when_specify_formatter
    formatters = %w[json pp pry]

    formatters.each do |formatter|
      opt = Rpr.parse_args(['-f', formatter])
      assert { opt[:formatter] == formatter.to_sym }
      assert { opt[:version] == false }
      assert { opt[:parser].is_a? Symbol }
      assert { opt[:expression].nil? }
    end
  end

  def test_parse_args_when_specify_expression
    opt = Rpr.parse_args(['-e', 'puts foo'])
    assert { opt[:formatter].is_a? Symbol }
    assert { opt[:version] == false }
    assert { opt[:parser].is_a? Symbol }
    assert { opt[:expression] == 'puts foo' }
  end
end
