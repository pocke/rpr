require 'ripper'

module Rpr
  module Parser
    module Tokenize
      def self.parse(code)
        return Ripper.tokenize(code)
      end
    end
  end
end
