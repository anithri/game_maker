require 'game_master'
module GameMaster
  module Base
    def self.included base
      base.send :include, InstanceMethods
      base.send :include, GameMaster::Loggable
      base.extend ClassMethods
      base.send :include, GameMaster::BaseAttributes
      base.send :include, GameMaster::BaseCollections
      base.send :attr_reader, :config
    end

    module InstanceMethods
      def initialize(config = {})
        @config = config
        assign_defined_children
      end

      def assign_defined_children
        self.all_children[:attribute].each_pair do |key,value|

        end
        self.all_children[:collection].each_pair do |key,value|

        end
      end
    end

    module ClassMethods
      def all_children
        @all_children ||= Hash.new{|h,k| h[k] = {}}
      end

      def parents
        @parents ||= self.name.to_s.split("::")
      end

      private

      def child_defined?(name)
        all_children[:attribute].fetch(name, false) || all_children[:collection].fetch(name, false)
      end
    end
  end
end
