require 'minruby'

module Rpr
  module Parser
    module Minruby
      def self.parse(code)
        minruby_parse(code)
      end
    end
  end
end
