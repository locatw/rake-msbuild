require 'spec_helper'
require File.expand_path('../../../lib/vsrake/vsrake_module', __FILE__)

describe "VSRake" do
  include VSRake

  context ".configure" do
    it "configures MSBuild task setting" do
      VSRake.configure do |c|
        c.exe = 'msbuild.exe'
        c.solution = 'sample.sln'
      end

      cxt = VSRake.build_task.context
      expect(cxt.exe).to eq('msbuild.exe')
      expect(cxt.solution).to eq('sample.sln')
    end

    it "generates a rake task named 'build'" do
      task_names = Rake.application.tasks.map{|t| t.name}
      expect(task_names).to include('build')
    end
  end
end
