require "rpr/version"
require 'ripper'
require 'optparse'

module Rpr
  # XXX: It should not be const.
  OPT = {
    formatter: :pp,
    version: nil,
    method: :sexp,
  }

  def self.run
    opt = OptionParser.new

    opt.on('-f=VAL', '--formatter=VAL'){|v| OPT[:formatter] = v.to_sym}
    opt.on('-o=VAL', '--out=VAL'){|v| $stdout = File.new(v, 'w')}
    opt.on('-m=VAL', '--method=VAL'){|v| OPT[:method] = v}
    opt.on('-v', '--version'){|v| OPT[:version] = v}

    opt.parse!(ARGV)

    if OPT[:version]
      require 'rpr/version'
      puts VERSION
    end

    ARGV.each do |fname|
      code = File.read(fname)
      res = Ripper.__send__ OPT[:method], code

      case OPT[:formatter]
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
        raise "#{OPT[:formatter]} is unknown formatter."
      end
    end

    $stdout.close
  end
end
