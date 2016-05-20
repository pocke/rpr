# Rpr searchs config file h from ./.rpr, ~/.config/rpr
module Rpr
  module Config
    class << self
      def laod
        fname = ['./.rpr', File.expand_path('~/.config/rpr')].find{|path| File.exist?(path)}
        return load_file(fname)
      end


      private

      def load_file(fname)
        return [] unless fname
        File.read(fname).split(' ')
      end
    end
  end
end
