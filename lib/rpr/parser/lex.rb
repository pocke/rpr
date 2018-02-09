require 'ripper'

module Rpr
  module Parser
    module Lex
      def self.parse(code)
        return Ripper.lex(code)
      end
    end
  end
end
