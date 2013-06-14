module GameMaster
  module BaseAttributes

    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods
      def define_attribute_class(new_val)
        logger.info "Defining new Attribute Class for #{self.class}"
        @attribute_class = new_val
      end

      def attribute_class
        @attribute_class ||= GameMaster::Attribute
      end

      def define_attribute(name, opts = {})
        name = name.to_sym
        type = opts.delete(:type) || Object
        default = opts.delete(:default)
        handle_attribute(name, type, default, parents, opts)
      end

      private

      def handle_attribute(name, type, default, parents, opts)
        if ok_to_add_attribute?(name)
          prep_attribute(name, type, default, parents, opts)
          methods_for_attribute(name)
        elsif opts.fetch(:may_redefine, false)
          logger.warn indent + "Redefining Attribute #{name} for #{self.name}"
          prep_attribute(name, type, default, parents, opts)
        else
          msg = "Refusing to redefine #{name} for #{self.name}"
          logger.error indent + msg
          raise GameParseError.new(msg) unless opts.fetch(:warn_only, false)
        end
      end

      def ok_to_add_attribute?(name)
        ! child_defined?(name)
      end

      def attribute_defined?(name)
        all_children[:attribute].keys.include?(name)
      end

      def prep_attribute(name, type, default, parents, opts)
        all_children[:attribute][name] = attribute_class.new(name, type, default, parents, opts)
      end

      def methods_for_attribute(name)
        define_method(name){self.class.all_children[:attribute][name].value}
        define_method("#{name}?"){self.class.all_children[:attribute][name].value}
        define_method("#{name}="){|new_value| self.class.all_children[:attribute][name].value= new_value}
        define_method("#{name}_type"){self.class.all_children[:attribute][name].type}
        define_method("#{name}_default"){self.class.all_children[:attribute][name].default}
        define_method("#{name}_default=") do
          |new_value| self.class.all_children[:attribute][name].default= new_value
        end

      end

    end
  end
end