module GameMaster
  module Utils
    def find_module(*possible_module_names)
      possible_module_names.map{|m| module_exists?(m)}.find{|m| m}
    end

    def module_exists?(name)
      mod = nil
      begin
        mod = Module.const_get(name)
      rescue NameError
        return false
      else
        return mod
      end
    end

    def name_from_file(filename)
      File.basename(filename, File.extname(filename))
    end
  end
end
