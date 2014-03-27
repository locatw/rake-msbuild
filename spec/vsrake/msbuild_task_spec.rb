require 'rake'
require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../lib/vsrake/msbuild_task', __FILE__)

module VSRake
  describe 'MSBuildTask' do
    before do
      Rake.application = Rake::Application.new
      MSBuildTask.new.generate_build_tasks
      @tasks = Rake.application.tasks
    end

    it "generates a task named 'build'" do
      task_names = []
      @tasks.each do |t|
        task_names << t.name
      end
      expect(task_names).to be_include("build")
    end
  end
end
