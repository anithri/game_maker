module GameMaster
  module Loggable
    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
      Yell.new :stdout, name: 'GameMaster' unless Yell::Repository.loggers.has_key?('GameMaster')
    end

    module InstanceMethods
      def logger
        Yell['GameMaster']
      end
    end

    module ClassMethods
      def logger
        Yell['GameMaster']
      end
    end
  end
end
