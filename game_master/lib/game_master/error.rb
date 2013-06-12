module GameMaster
  class Error
    class << self
      def missing_required_field(klass, config)
        msg = "#{klass} can't be initialized with all required fields\n" +
              "  Given: #{config}\n" +
              "  Required: #{klass.required_children}"
        GameParseError.new(msg)
      end
    end
  end
end