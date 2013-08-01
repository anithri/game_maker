module GameMaster
  module ConfigLoader
    class Base
      def initialize(tracker)
        @stages = tracker.stages
      end

      def clear_all_stages
        @stages = []
      end

      def add_stage(new_stage)
        raise ArgumentError, "stages must respond to #load and #priority" unless new_stage.respond_to()
      end

      def reset_stages
        @stages = DEFAULT_STAGES.dup
      end

      def load(game,loader,runtime)
        config = GameMaster::Config.new(game,loader,runtime)
        config.boot.stages = []
        config.boot.all_stages = []

        ordered_stages.each do |stage|
          config.boot.all_stages << stage
          stage.load(config)
        end
        config
      end

    end
  end
end