require 'json'

module Rpr
  module Formatter
    module Json
      def self.print(object)
        puts JSON.pretty_generate(object)
      end
    end
  end
end
