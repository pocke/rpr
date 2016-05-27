require 'rubocop'

module Rpr
  module Parser
    module Rubocop
      def self.parse(code)
        r = RuboCop::ProcessedSource.new(code, RUBY_VERSION.to_f)
        return r.ast
      end
    end
  end
end
