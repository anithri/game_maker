
module GameMaster
  class Attribute
    include Loggable

    # @!attribute [r] name
    #   @return [Symbol] name of the attribute
    # @!attribute [r] type
    #   @return [Class] Expected class of the attribute
    # @!attribute [r] default
    #   @return [Symbol] the default value of the attribute
    # @!attribute [r] opts
    #   @return [Hash<Boolean>] options of the attribute
    # @!attribute [r] value
    #   @return [Symbol] value of the attribute
    # @!attribute [rw] parents
    attr_reader :name, :type, :default, :opts, :value, :parents

    # @param [#to_sym] name name of attribute
    # @param [Class] type expected class of attribute
    # @param [Object] default default value of class

    # @param [Object] opts additional options
    # @options opts [Boolean] :ignore_type if true, skip type check
    # @options opts [Boolean] :warn_only if true, don't raise error if type is mismatched
    # @options opts [#each<#to_s>] :parents Array of hierarchy this attribute belongs to if any
    # @return [GameMaker::Attribute]
    def initialize(name, type, default, my_parents = [], opts = {})
      @name, @type, @default, @opts = name, type, default, opts.dup
      set_parents(my_parents)
      @value = @default
      logger.info defined_message
    end

    # @param [Object] new_value the value to set
    # @raise [ArgumentError] if new_value is not the right class and the :warn_only option is false
    # @return [Object] will return new_value is right type else return existing value
    # when it will return it current value
    def value=(new_value)
      if ok_to_assign?(new_value)
        logger.info success_message(new_value)
        @value = new_value
      elsif opts.fetch(:warn_only, false)
        logger.warn failure_message(new_value)
        return value
      else
        logger.warn failure_message(new_value)
        raise ArgumentError.new(failure_message(new_value))
      end
    end

    # @return [String] elemts of parents are e.to_s.upper_camelcase, have the name added and then
    # joined by "::"
    # @example if #parents return [GameMaster,:foo_bar, "Baz"], and name was :test
    #    #full_name #=> "GameMaster::FooBar::Baz::Test"
    def full_name
      [parents, name].flatten.map{|e| e.to_s.upper_camelcase}.join("::")
    end

    def set_parents(*arr)
      @parents = arr.flatten.compact
    end

    private

    def ok_to_assign?(new_value)
      new_value.kind_of?(type) || opts.fetch(:ignore_type, false)
    end

    def defined_message
      indent +
      "New attribute defined: #{name_type(full_name,type)}"
    end

    def success_message(new_val)
      indent +
      "assigned to attribute #{full_name}: #{new_val.inspect}"
    end

    def failure_message(new_val)
      indent +
      "failed assignment to attribute " +
      name_type(full_name,type) +
      ": " +
      name_type(new_val.inspect,new_val.class)
    end

    def indent
      "  " * parents.count
    end

    def name_type(name, type)
      "#{name}<#{type}>"

    end
  end
end