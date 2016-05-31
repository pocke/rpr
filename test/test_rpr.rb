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
  end

  def test_parse_args_when_specify_pry_formatter
    opt = Rpr.parse_args(['-f', 'pry'])
    assert { opt[:formatter] == :pry }
    assert { opt[:version] == false }
    assert { opt[:parser].is_a? Symbol }
  end
end
