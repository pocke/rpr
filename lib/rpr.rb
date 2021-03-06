require "rpr/version"
require 'rpr/config'

require 'ripper'
require 'optparse'
require 'stringio'

module Rpr
  class UnknownFormatter < ArgumentError; end
  class UnknownParser < ArgumentError; end

  class << self
    # @param [Array<String>] args
    def run(args)
      options = parse_args(args)

      if options[:version]
        require 'rpr/version'
        puts VERSION
      end

      parser = find_parser(options[:parser])
      formatter = find_formatter(options[:formatter])

      if options[:expression]
        res = parser.parse(options[:expression])
        formatter.print(res)
      else
        args.each do |fname|
          code = File.read(fname)
          res = parser.parse(code)

          formatter.print(res)
        end
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
      raise UnknownFormatter, "#{name} is unknown formatter. It supports #{self.formatters.join('|')}"
    end

    def formatters
      Dir.glob(File.join(__dir__, 'rpr/formatter/*.rb'))
        .map { |fname| File.basename(fname, '.rb')}
    end

    # @param [Symbol] name
    # @return [Module]
    def find_parser(name)
      require "rpr/parser/#{name}"
      Parser.const_get(:"#{name[0].upcase}#{name[1..-1]}")
    rescue LoadError
      raise UnknownParser, "#{name} is unknown parser. It supports #{self.parsers.join('|')}"
    end

    def parsers
      Dir.glob(File.join(__dir__, 'rpr/parser/*.rb'))
        .map { |fname| File.basename(fname, '.rb')}
    end

    # @param [Array<String>] args
    def parse_args(args)
      res = {
        formatter: :pp,
        version: false,
        parser: :rubocop,
        expression: nil,
      }

      opt = OptionParser.new

      opt.on('-f=FORMATTER', '--formatter=FORMATTER', self.formatters.join('|')){|v| res[:formatter] = v.to_sym}
      opt.on('-o=FILE', '--out=FILE'){|v| $stdout = File.new(v, 'w')}
      opt.on('-p=PARSER', '--parser=PARSER', self.parsers.join('|')){|v| res[:parser] = v.to_sym}
      opt.on('-e=CODE'){|v| res[:expression] = v}
      opt.on('-v', '--version'){|v| res[:version] = v}

      opt.parse!(args)

      res
    end
  end
end
