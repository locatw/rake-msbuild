module VSRake
  class VsProject
    attr_reader :name, :path, :guid, :type

    def initialize(name, path, guid, type)
      path = replace_path_separator(path)
      @name, @path, @guid, @type = name, path, guid, type
    end

    private

    def replace_path_separator(path)
      path.gsub(/\\/, '/')
    end
  end
end
