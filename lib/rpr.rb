require "rpr/version"
require 'rpr/config'

require 'ripper'
require 'optparse'

module Rpr
  class << self
    # @param [Array<String>] args
    def run(args)
      options = parse_args(args)

      if options[:version]
        require 'rpr/version'
        puts VERSION
      end

      formatter = find_formatter(options[:formatter])
      parser = find_parser(options[:parser])
      args.each do |fname|
        code = File.read(fname)
        res = parser.parse(code)

        formatter.print(res)
      end
    ensure
      $stdout.close unless $stdout.tty?
    end

    # @param [Symbol] name
    # @return [Module]
    def find_formatter(name)
      require "rpr/formatter/#{name}"
      Formatter.const_get(:"#{name[0].upcase}#{name[1..-1]}")
    rescue LoadError
      raise "#{name} is unknown formatter."
    end

    # @param [Symbol] name
    # @return [Module]
    def find_parser(name)
      require "rpr/parser/#{name}"
      Parser.const_get(:"#{name[0].upcase}#{name[1..-1]}")
    rescue LoadError
      raise "#{name} is unknown parser."
    end

    # @param [Array<String>] args
    def parse_args(args)
      res = {
        formatter: :pp,
        version: false,
        parser: :sexp,
      }

      opt = OptionParser.new

      opt.on('-f=VAL', '--formatter=VAL'){|v| res[:formatter] = v.to_sym}
      opt.on('-o=VAL', '--out=VAL'){|v| $stdout = File.new(v, 'w')}
      opt.on('-p=VAL', '--parser=VAL'){|v| res[:parser] = v.to_sym}
      opt.on('-v', '--version'){|v| res[:version] = v}

      opt.parse!(args)

      res
    end
  end
end
