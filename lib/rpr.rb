require "rpr/version"
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

      ARGV.each do |fname|
        code = File.read(fname)
        res = Ripper.__send__ options[:method], code

        case options[:formatter]
        when :pp
          require 'pp'
          pp res
        when :pry
          raise "Can't specify --out option with pry formatter" unless $stdout.tty?
          require 'pry'
          binding.pry(res)
        when :json
          require 'json'
          puts JSON.pretty_generate(res)
        else
          raise "#{options[:formatter]} is unknown formatter."
        end
      end
    ensure
      $stdout.close unless $stdout.tty?
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
