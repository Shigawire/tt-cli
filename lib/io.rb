module Tt
  module IO
    class Interface
      def self.read path
        File.read path
      end

      def self.write path, data
        File.write path, data
      end
    end
  end
end
