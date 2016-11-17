require 'ruby_parser'

module Rpr
  module Parser
    module Rubyparser
      def self.parse(code)
        ::RubyParser.new.parse(code)
      end
    end
  end
end
