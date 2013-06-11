module GameMaster
  class Collection
    include Loggable

    # @!attribute [r] name
    #   @return [Symbol] name of the attribute
    # @!attribute [r] type
    #   @return [Class] Expected class of the attribute
    # @!attribute [r] opts
    #   @return [Hash<Boolean>] options of the attribute
    attr_reader :name, :type, :opts, :parents

    # @param [#to_sym] name name of attribute
    # @param [Class] type expected class of attribute
    # @param [#each<#to_s>] parents array of parents of this collection
    # @param [Object] opts additional options
    # @options opts [Boolean] :ignore_type if true, skip type check
    # @options opts [Boolean] :warn_only if true, don't raise error if type is mismatched
    # @return [GameMaker::Collection]
    def initialize(name, type, my_parents = [], opts = {})
      @name, @type, @opts = name, type, opts.dup
      set_parents(my_parents)
      @members = []
      logger.info defined_message
    end

    def full_name
      [parents, name].flatten.map{|e| e.to_s.upper_camelcase}.join("::")
    end

    def to_ary
      @members
    end

    def set_parents(*arr)
      @parents = arr.flatten.compact
    end

    def add_child(new_value)
      if ok_to_add?(new_value)
        logger.info add_success_msg(new_value)
        @members << new_value
      elsif opts.fetch(:warn_only, false)
        logger.warn add_failure_msg(new_value)
        return @members
      else
        logger.error add_failure_msg(new_value)
        raise ArgumentError.new(add_failure_msg(new_value))
      end
    end

    protected

    def ok_to_add?(new_value)
      new_value.kind_of?(type) || opts.fetch(:ignore_type, false)
    end

    def defined_message
      indent +
      "New collection defined: #{name_type(full_name,type)}"
    end

    def name_type(name,type)
      "#{name}<#{type}>"
    end

    def indent
      "  " * parents.length
    end

    def add_success_msg(new_value)
      indent +
      "added to collection #{full_name}: #{new_value}"
    end

    def add_failure_msg(new_value)
      indent +
      "failed adding member to collection " +
      name_type(full_name, type) +
      ": " +
      name_type(new_value,new_value.class)
    end
  end
end