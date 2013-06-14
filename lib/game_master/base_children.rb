module GameMaster
  module BaseChildren
    def self.included base
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def initialize_children(opts = {})
        self.class.children_names.each do |child|
          next unless opts.has_key?(child)
          if children[child].fetch(:collection, false)
            send("add_#{child}", opts[child])
          else
            send("#{child}=", opts[child])
          end
        end
      end

      def children_names
        self.class.children.keys
      end

      def children
        self.class.children
      end

      private

      def has_all_required_fields?(opts)
        self.class.required_children.all?{|rc| opts.has_key?(rc)}
      end

    end

    module ClassMethods

      def children
        @children ||= {}
      end

      def children_names
        @children.keys
      end

      def required_children
        children.keys.select{|c| children[c].fetch(:required, false)}
      end

      def define_attribute(name, opts = {})
        opts[:default] ||= nil
        opts[:type] ||= Object
        children[name] = opts
        add_attribute_methods(name,opts[:type],opts[:default])
      end

      def define_collection(name, opts = {})
        opts[:type] ||= Object
        opts[:collection] = true
        opts[:unique] ||= nil
        children[name] = opts
        if opts[:unique]
          #use a Hash
          add_hash_collection_methods
        else
          #Use an Array
          add_collection_methods(name, opts[:type])
        end
      end

      def handle_error(error_type, *args)
        case error_type
        when :assignment
          msg = "Error assigning to %s.  %s should be a %s" % args
          raise_ex = true
        when :required_field
          msg = "Can't make new instance of %s.  %s is missing required fields: %s" % args
          raise_ex = true
        end
        logger.error msg
        raise GameParseError.new(msg) if raise_ex
      end

      private

      def add_attribute_methods(name, type, default)
        class_eval(<<-EOS, __FILE__, __LINE__ + 1)

          cattr_accessor :#{name}_type, :#{name}_default
          @@#{name}_type = type
          @@#{name}_default = #{default.inspect}

          def #{name}
            @#{name} ||= @@#{name}_default
          end

          def #{name}?
            !! #{name}
          end

          def #{name}=(new_value)
            new_value = #{attribute_assignment_string(type)}
            #handle_error(:assignment, #{name}, new_value, #{type}) unless new_value.is_a?(@@#{name}_type)
            @#{name} = new_value
          end

        EOS
      end

      def add_collection_methods(name, type)
        class_eval(<<-EOS, __FILE__, __LINE__ + 1)

          cattr_accessor :#{name}_type
          @@#{name}_type = #{type}

          def #{name}
            @#{name} ||= []
          end

          def add_#{name}(new_value)
            new_value = #{collection_assignment_string(type)}
            raise_assignment_error(#{name},#{name}_type.inspect,new_value.inspect) unless new_value.is_a?(#{name}_type)
            #{name} << new_value
          end

        EOS
      end


      def attribute_assignment_string(type)
        if type.methods.include?(:new) && type != Object
          "#{type}.new(new_value)"
        else
          "new_value"
        end
      end

      def collection_assignment_string(type)
        if type.methods.include?(:new) && type != Object
          "#{type}.new(new_value)"
        else
          "new_value"
        end
      end
    end
  end
end
