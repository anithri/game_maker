require 'facets'
require 'facets/module/mattr'
require 'facets/string/snakecase'

module StreetsOfGotham
  class BaseType
    cattr_accessor :children, :fields
    @@children = {}
    @@fields = {}

    def self.add_children(*list)
      list.each do |e|
        self.add_child(*child_info(e))
      end
    end

    def self.define_children(options = {})
      options.each do |name, klass|
        self.add_child(name.intern, klass)
      end
    end

    def self.has_fields(*list)
      list.each do |e|
        self.add_field(*field_info(e))
      end
    end

    def self.define_fields(options = {})
      options.each do |name, klass|
        self.add_field(name, klass)
      end
    end

    def self.valid?(options)
      is_valid = true
      is_valid &&= options.is_a?(Hash)
      self.all_required_fields.each do |k,v|
        is_valid &&= options.has_key?(k)
        is_valid &&= options.fetch(k).is_a?(v) unless v.nil?
      end
      is_valid
    end

    private

    def self.add_child(name, klass)
      @@children[name] = klass
    end

    def self.child_info(var)
      if var.is_a?(Class)
        return [name_for(var), var]
      else
        return [var.intern, class_for(var)]
      end
    end

    def self.assign_required_field(name, klass = Object)
      @@all_children[name] = klass
    end

    def self.name_for(klass)
      klass.to_s.split("::").last.snakecase.to_sym
    end

    def self.class_for(name)
      Object.const_get name.to_s.modulize
    end
  end
end