require 'rubocop'

module Rpr
  module Parser
    module Rubocop
      def self.parse(code)
        version = RUBY_VERSION.to_f
        # XXX: Parser gem does not support Ruby 2.6
        version = 2.5 if version == 2.6
        r = RuboCop::ProcessedSource.new(code, version)
        return r.ast
      end
    end
  end
end
