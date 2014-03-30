require File.expand_path('../vs_project', __FILE__)
require File.expand_path('../vs_solution_parser', __FILE__)

module VSRake
  class VsSolution
    
    attr_reader :solution_path, :projects

    def initialize
      @solution_path = ""
      @projects = []
    end

    def load(solution_path)
      @solution_path = solution_path
      parser = create_parser
      projects = parser.parse(@solution_path)
      projects.each do |proj|
        @projects << VsProject.new(proj[:name], proj[:path], proj[:guid], proj[:type])
      end
    end

    def project(project_name)
      @projects.find {|proj| proj.name == project_name}
    end

    private

    def create_parser
      VsSolutionParser.new
    end
  end
end

