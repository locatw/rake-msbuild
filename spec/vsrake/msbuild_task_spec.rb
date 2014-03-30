require 'rake'
require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../lib/vsrake/msbuild_task', __FILE__)

module VSRake
  describe 'MSBuildTask' do
    before do
      Rake.application = Rake::Application.new
      MSBuildTask.new.generate_build_tasks
      tasks = Rake.application.tasks
      @task_names = Rake.application.tasks.map {|t| t.name}
    end

    it "generates a task named 'build'" do
      expect(@task_names).to include("build")
    end

    it "generates a task named 'build_project'" do
      expect(@task_names).to include("build_project")
    end
    
    it "generates a task named 'rebuild'" do
      expect(@task_names).to include("rebuild")
    end
  end
end
