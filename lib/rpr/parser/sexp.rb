require 'ripper'

module Rpr
  module Parser
    module Sexp
      def self.parse(code)
        return Ripper.sexp(code)
      end
    end
  end
end
