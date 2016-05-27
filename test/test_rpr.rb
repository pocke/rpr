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
end
