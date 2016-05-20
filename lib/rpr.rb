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
      ARGV.each do |fname|
        code = File.read(fname)
        res = Ripper.__send__ options[:method], code

        formatter.print(res)
      end
    ensure
      $stdout.close unless $stdout.tty?
    end

    # @param [String] name
    # @return [Module]
    def find_formatter(name)
      require "rpr/formatter/#{name}"
      Formatter.const_get(:"#{name[0].upcase}#{name[1..-1]}")
    rescue LoadError
      raise "#{name} is unknown formatter."
    end

    # @param [Array<String>] args
    def parse_args(args)
      res = {
        formatter: :pp,
        version: false,
        method: :sexp,
      }

      opt = OptionParser.new

      opt.on('-f=VAL', '--formatter=VAL'){|v| res[:formatter] = v.to_sym}
      opt.on('-o=VAL', '--out=VAL'){|v| $stdout = File.new(v, 'w')}
      opt.on('-m=VAL', '--method=VAL'){|v| res[:method] = v}
      opt.on('-v', '--version'){|v| res[:version] = v}

      opt.parse!(args)

      res
    end
  end
end
