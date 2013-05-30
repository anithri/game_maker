module GameMaster
  module BaseComponents

    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods
      def reset_components!
        @component_class = @components = nil
      end

      def define_component_class(new_val)
        @component_class = new_val
      end

      def component_class
        @component_class ||= GameMaster::Component
      end

      def all_components
        @components ||= Hash.new{|h,k| h[k] = []}
      end

      def define_component(name, opts = {})
        name = name.to_sym
        type = opts.delete(:type) || Object
        default = opts.delete(:default)
        opts[:parents] = parents
        handle_component(name, type, default, opts)
      end

      private

      def handle_component(name, type, default, opts)
        if ok_to_add_component?(name)
          prep_component(name, type, default, opts)
          methods_for_component(name)
        elsif opts.fetch(:may_redefine, false)
          logger.warn indent + "Redefining Component: #{name}"
          prep_component(name, type, default, opts)
        else
          msg = "Refusing to redefine #{name} for #{self.name}"
          logger.error indent + msg
          raise GameParseError.new(msg) unless opts.fetch(:warn_only, false)
        end
      end

      def ok_to_add_component?(name)
        ! any_defined?(name)
      end

      def component_defined?(name)
        all_components.keys.include?(name)
      end

      def prep_component(name, type, default, opts)
        all_components[name] = component_class.new(name, type, default, opts)
      end

      def methods_for_component(name)
        define_method(name){self.class.all_components[name].value}
        define_method("#{name}?"){self.class.all_components[name].value}
        define_method("#{name}="){|new_value| self.class.all_components[name].value= new_value}
        define_method("#{name}_type"){self.class.all_components[name].type}
      end
    end
  end
end