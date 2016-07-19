require 'test_helper'

class TestRpr < Minitest::Test
  def test_find_formatter
    formatters = %w[json pp pry]

    formatters.each do |formatter|
      f = Rpr.find_formatter(formatter)
      assert { f.is_a? Module }
      assert { f.respond_to? :print }
    end
  end

  def test_find_formatter_with_unknown_formatter
    Rpr.find_formatter(SecureRandom.hex(20))
  rescue Rpr::UnknownFormatter => ex
  else
    raise "Should raise UnknownFormatter, but not raise"
  end

  def test_find_parser
    parsers = %w[parser rubocop sexp tokenize]

    parsers.each do |parser|
      f = Rpr.find_parser(parser)
      assert { f.is_a? Module }
      assert { f.respond_to? :parse }
    end
  end

  def test_find_parser_with_unknown_parser
    Rpr.find_parser(SecureRandom.hex(20))
  rescue Rpr::UnknownParser => ex
  else
    raise "Should raise UnknownParser, but not raise"
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
