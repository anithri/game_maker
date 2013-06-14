
module GameMaster
  class Children

    attr_reader :parents, :children, :all_attributes, :all_collections

    @@all_children = {}

    def self.for(name, parents = [])
      parents << name
      @@all_children[name] ||= self.new(parents)
    end

    def add_child(name, opts)
      children[name] = mk_child(name, opts)
    end

    def names
      children.keys
    end

    private

    def mk_child(name, opts)
      child_type(name, opts.fetch(:collection, false)).new(name, opts)
    end

    def initialize(parents)
      @children = {}
      @parents = parents
    end

    def child_type(name, collection = false)
      return GameMaster::Collection if collection
      return GameMaster::Attribute
    end
  end
end
