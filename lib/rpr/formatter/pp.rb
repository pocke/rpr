require 'pp'

module Rpr
  module Formatter
    module Pp
      def self.print(object)
        pp object
      end
    end
  end
end
