module GameMaster
  module ConfigLoader
    class StageTrackerBase

      def initialize
        @all_stages = Hash.new{|h,k| h[k] = [];h}
      end

      def stages
        sort_stages
      end

      def register_stage(new_stage, priority)
        return add_stage(new_stage, priority) if is_valid_stage?(new_stage)
        raise ArgumentError, "#{new_stage} does not respond_to .load"
      end

      def unregister_stage(stage, *priorities)
        remove_stage(stage, priorities)
      end

      def is_valid_stage?(stage)
        stage.respond_to?(:load)
      end

      private
      def add_stage(stage, priority)
        @all_stages[priority] << stage unless @all_stages[priority].include?(stage)
      end

      def remove_stage(stage, priorities)
        priorities.each do |priority|
          @all_stages[priority].delete(stage)
        end
      end

      def sort_stages
        @all_stages.keys.sort.map{|k| @all_stages[k]}.inject([]){|arr,el| arr << el; arr}.flatten
      end
    end

    class StageTracker < StageTrackerBase
      include Singleton
    end
  end
end
