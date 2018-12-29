module Rpr
  module Formatter
    module UnifiedInterface
      refine Object do
        def node_value() inspect end
        def traversable?() false end
      end

      if defined?(Rpr::Parser::Sexp)
        refine Array do
          def node_value() traversable? ? self[0].to_s : super end
          def children
            res = []
            self[1..-1].each do |child|
              if child.is_a?(Array) &&
                 !child.traversable? &&
                 !(child.size == 2 && child[0].is_a?(Integer) && child[1].is_a?(Integer))
                res.concat(child)
              else
                res << child
              end
            end
            res
          end
          def traversable?() self.first.is_a?(Symbol) end
        end
      end

      if defined?(Rpr::Parser::Parser) || defined?(Rpr::Parser::Rubocop)
        refine ::Parser::AST::Node do
          def node_value() self.type.to_s end
          def traversable?() true end
        end
      end

      if defined?(Rpr::Parser::Rubyparser)
        refine Sexp do
          def node_value() self.sexp_type.to_s end
          def children() self.each.to_a end
          def traversable?() true end
        end
      end

      if defined?(Rpr::Parser::Rubyvm_ast)
        refine RubyVM::AbstractSyntaxTree::Node do
          def node_value() self.type.to_s end
          def traversable?() true end
        end
      end
    end

    # Formatter for Graphviz
    class Dot
      using UnifiedInterface

      def self.print(object)
        self.new.print(object)
      end

      def initialize
        @id = :a
      end

      def print(object)
        puts 'digraph{graph [dpi=288;];'
        traverse_and_print(object)
        puts "}"
      end

      private

      def traverse_and_print(object, parent = 'ROOT')
        label = object.node_value
        shape = object.traversable? ? 'oval' : 'box'
        id = gen_id()

        puts "#{parent} -> #{id}"
        puts "#{id}[ label=#{label.inspect} shape=#{shape} ]"

        if object.traversable?
          object.children.each do |child|
            traverse_and_print(child, id)
          end
        end
      end

      def gen_id
        @id = @id.succ
      end
    end
  end
end
