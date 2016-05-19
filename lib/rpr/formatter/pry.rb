require 'pry'

module Rpr
  module Formatter
    module Pry
      def self.print(object)
        raise "Can't specify --out option with pry formatter" unless $stdout.tty?
        binding.pry(object)
      end
    end
  end
end
