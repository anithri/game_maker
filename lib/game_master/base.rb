require 'game_master'
module GameMaster
  module Base
    def self.included base
      base.send :include, InstanceMethods
      base.send :include, GameMaster::Loggable
      base.send :include, Attrio
      base.extend ClassMethods
      base.send :attr_reader, :config
    end

    module InstanceMethods
      def initialize(config = {})
        raise ArgumentError.new("#{self.class} called with #{config.inspect}, but should have been called with a GameMaster::Config") unless config.is_a?(GameMaster::Config)
        @config = config
        super()
        config.game.each do |key, value|
          self.send("#{key}=", value) if self.respond_to?("#{key}=")
          self.send("add_#{key}", value) if self.respond_to?("add_#{key}")
        end
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
