module GameMaster
  module BaseAttributes

    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods
      def reset_attributes!
        @attribute_class = @attributes = nil
      end

      def define_attribute_class(new_val)
        @attribute_class = new_val
      end

      def attribute_class
        @attribute_class ||= GameMaster::Attribute
      end

      def all_attributes
        @attributes ||= {}
      end

      def define_attribute(name, opts = {})
        name = name.to_sym
        type = opts.delete(:type) || Object
        default = opts.delete(:default)
        opts[:parents] = parents
        handle_attribute(name, type, default, opts)
      end

      private

      def handle_attribute(name, type, default, opts)
        if ok_to_add_attribute?(name)
          prep_attribute(name, type, default, opts)
          methods_for_attribute(name)
        elsif opts.fetch(:may_redefine, false)
          logger.warn indent + "Redefining Attribute: #{name}"
          prep_attribute(name, type, default, opts)
        else
          msg = "Refusing to redefine #{name} for #{self.name}"
          logger.error indent + msg
          raise GameParseError.new(msg) unless opts.fetch(:warn_only, false)
        end
      end

      def ok_to_add_attribute?(name)
        ! any_defined?(name)
      end

      def attribute_defined?(name)
        all_attributes.keys.include?(name)
      end

      def prep_attribute(name, type, default, opts)
        all_attributes[name] = attribute_class.new(name, type, default, opts)
      end

      def methods_for_attribute(name)
        define_method(name){self.class.all_attributes[name].value}
        define_method("#{name}?"){self.class.all_attributes[name].value}
        define_method("#{name}="){|new_value| self.class.all_attributes[name].value= new_value}
        define_method("#{name}_type"){self.class.all_attributes[name].type}
      end
    end
  end
end