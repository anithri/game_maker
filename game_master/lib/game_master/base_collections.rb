module GameMaster
  module BaseCollections

    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods
      def define_collection_class(new_val)
        logger.info indent + "Defining new Collection Class for #{self.class}"
        @collection_class = new_val
      end

      def collection_class
        @collection_class ||= GameMaster::Collection
      end

      def define_collection(name, opts = {})
        name = name.to_sym
        type = opts.delete(:type) || Object
        opts[:parents] = parents || []
        handle_collection(name, type, parents, opts)
      end

      private

      def handle_collection(name, type, parents, opts)
        if ok_to_add_collection?(name)
          prep_collection(name, type, parents, opts)
          methods_for_collection(name)
        elsif opts.fetch(:may_redefine, false)
          logger.warn indent + "Redefining Component: #{name}"
          prep_collection(name, type, default, opts)
        else
          msg = "Refusing to redefine #{name} for #{self.name}"
          logger.error indent + msg
          raise GameParseError.new(msg) unless opts.fetch(:warn_only, false)
        end
      end

      def ok_to_add_collection?(name)
        ! child_defined?(name)
      end

      def collection_defined?(name)
        all_children.keys.include?(name)
      end

      def prep_collection(name, type, parents, opts)
        all_children[name] = collection_class.new(name, type, parents, opts)
      end

      def methods_for_collection(name)
        define_method(name){self.class.all_children[name].to_ary}
        define_method("#{name}<<"){self.class.all_children[name].add(value)}
        define_method("#{name}_type"){self.class.all_children[name].type}
      end
    end
  end
end