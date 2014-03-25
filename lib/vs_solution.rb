require File.expand_path('../vs_project', __FILE__)
require File.expand_path('../vs_solution_parser', __FILE__)

module VSRake
  class VsSolution
    
    attr_reader :projects

    def initialize()
      @projects = []
    end
    
    def load(sln_path)
      parser = VsSolutionParser.new
      projects = parse(read_sln(sln_path))
      projects.each do |proj|
        @projects << VsProject.new(proj[:name], proj[:path], proj[:guid], proj[:type])
      end
    end

    private

    def read_sln(sln_path)
      contents = ""
      File.open(sln_path) do |f|
        f.read(nil, contents)
      end

      contents
    end

    def parse(sln)
      parser.parse_project(sln)
    end
  end
end

