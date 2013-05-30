require 'game_master'
module GameMaster
  module Base
    def self.included base
      base.send :include, InstanceMethods
      base.send :include, GameMaster::Loggable
      base.extend ClassMethods
      base.send :include, GameMaster::BaseAttributes
      base.send :include, GameMaster::BaseComponents
      base.send :attr_reader, :config
    end

    module InstanceMethods
      def initialize(config = {})
        @config = config
      end
      def logger
        Yell['GameMaster']
      end
    end

    module ClassMethods
      def reset!
        @parents = nil
        reset_attributes!
        reset_components!
      end

      def parents
        @parents ||= self.name.split("::")
      end

      private

      def any_defined?(name)
        attribute_defined?(name) #|| component_defined?(name)
      end

      def indent
        "  " * parents.count
      end
    end
  end
end

module StreetsOfGotham
  class Board
    include ::GameMaster::Base
    define_attribute :description, type: String, default: ""
  end
end

