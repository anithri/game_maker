require 'game_master'
module GameMaster
  module Base
    def self.included base
      base.send :include, GameMaster::BaseChildren
      base.send :include, InstanceMethods
      base.send :include, GameMaster::Loggable
      base.extend ClassMethods
      base.send :attr_reader, :config
    end

    module InstanceMethods
      def initialize(config = {})
        raise ArgumentError.new("#{self.name} called with #{config}, but should have been called with a Hash") unless config.is_a?(Hash)
        @config = config
        initialize_children(config)
      end
    end

    module ClassMethods
      def parents
        @parents ||= []
      end

      def parent(value)
        parents << value
      end
    end
  end
end
