module Rpr
  module Parser
    module Rubyvm_ast
      def self.parse(code)
        return RubyVM::AbstractSyntaxTree.parse(code)
      end
    end
  end
end
