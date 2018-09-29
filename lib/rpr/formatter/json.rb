require 'json'

module Rpr
  module Formatter
    module Json
      def self.print(object)
        object = object.to_sexp_array if defined?(::Parser::AST::Node) && object.is_a?(::Parser::AST::Node)
        puts JSON.pretty_generate(object)
      end
    end
  end
end
