module VSRake
  class VsProject
    attr_reader :name, :path, :guid, :type

    def initialize(name, path, guid, type)
      @name, @path, @guid, @type = name, path, guid, type
    end
  end
end
