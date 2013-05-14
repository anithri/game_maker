require 'facets'
require 'facets/module/mattr'
require 'facets/string/snakecase'

module StreetsOfGotham
  class BaseType
    cattr_accessor :children, :fields
    attr_accessor :raw_data

    def self.reset!
      @@children = {}
      @@fields = {}
      @@base_module = self.to_s.split("::")[0..-2].join("::")
    end
    reset!

    def self.add_children(*list)
      list.each do |e|
        self.add_child(*self.child_info(e))
      end
    end

    def self.define_children(options = {})
      options.each do |name, klass|
        self.add_child(name.intern, self.class_for(klass))
      end
    end

    def self.add_fields(*list)
      list.each do |e|
        self.add_field(*self.child_info(e))
      end
    end

    def self.define_fields(options = {})
      options.each do |name, klass|
        self.add_field(name.intern, self.class_for(klass))
      end
    end

    def self.valid?(options)
      #warn "=" * 30
      #warn "fields: " + @@fields.inspect
      #warn "-" * 30
      #warn "children: " + @@children.inspect
      #warn "-" * 30
      #warn options.inspect
      #warn "=" * 30
      is_valid = true
      is_valid &&= options.is_a?(Hash)
      self.fields.each do |k,v|
        is_valid &&= options.has_key?(k)
        is_valid &&= options.fetch(k).is_a?(v) unless v.nil? || v.to_s ==
            "Object"
      end
      self.children.each do |k,v|
        is_valid &&= options.has_key?(k)
        is_valid &&= options[k].is_a? Array
        #TODO Add recursive validation here
      end
      is_valid
    end

    private

    def self.add_field(name, klass)
      @@fields[name] = klass
      attr_accessor name
    end

    def self.add_child(name, klass)
      @@children[name] = klass
      define_method("mk_#{name}") do |options|
        klass.new(options)
      end
    end

    def self.definition_info(var)
      if var.is_a?(Class)
        return [self.name_for(var), var]
      elsif var.respond_to?(:to_s)
        return [self.name_for(var), self.class_for(var)]
      else
        raise ArgumentError.new("Can't reliably convert #{var.inspect} to
both name and class")
      end
    end

    def self.child_info(var)
      if var.is_a?(Class)
        return [self.name_for(var), var]
      else
        return [var.intern, self.class_for(var)]
      end
    end

    def self.assign_required_field(name, klass = Object)
      @@all_children[name] = klass
    end

    def self.name_for(klass)
      klass.to_s.split("::").last.snakecase.to_sym
    end

    def self.class_for(name)
      return name if name.is_a?(Class)
      begin
        return Object.const_get name.to_s.modulize
      rescue NameError
        begin
          return Object.const_get("#{@@base_module}::#{name.to_s.modulize}")
        rescue NameError
          return Object
        end
      end
    end
  end
end