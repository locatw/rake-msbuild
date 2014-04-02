require 'spec_helper'
require File.expand_path('../../../lib/vsrake/vsrake_module', __FILE__)

describe "VSRake module" do
  include VSRake

  context "configure" do
    it "configures MSBuild task setting" do
      VSRake.configure do |c|
        c.exe = 'msbuild.exe'
        c.solution = 'sample.sln'
      end

      cxt = VSRake.build_task.context
      expect(cxt.exe).to eq('msbuild.exe')
      expect(cxt.solution).to eq('sample.sln')
    end
  end
end

def build_project_task?(build_type)
  build_type.end_with?("_project")
end

def rebuild_task?(build_type)
  build_type.start_with?("rebuild")
end
  
["build", "rebuild", "build_project", "rebuild_project"].each do |build_type|
  describe "generetaed task named '#{build_type}'" do
    include VSRake
  
    def initialize_rake
      Rake.application.clear
    end

    before do
      initialize_rake
      VSRake.build_task.context.options.clear
      
      VSRake.configure do |c|
        c.exe = 'msbuild.exe'
        c.solution = 'sample.sln'
      end
  
      @build_task = VSRake.build_task
      @build_task.stub(:execute_msbuild_command)
      if build_project_task?(build_type)
        project_stub = Class.new do
          def self.path
            "project1_path.proj"
          end
        end
        @build_task.stub(:find_project_by_name)
                   .and_return(project_stub)
      end
      
      @options = @build_task.context.options
    end

    context "with no build options" do
      it "execute #{build_type} with default options" do
        if build_project_task?(build_type)
          Rake::Task[build_type].invoke("Project1")
        else
          Rake::Task[build_type].invoke()
        end

        expect(@options).to include("/p:Configuration=Release")
        expect(@options).to include("/p:Platform=Win32")
        if rebuild_task?(build_type)
          expect(@options).to include("/t:Rebuild")
        end
      end
    end

    context "with configuration option that value is 'Debug'" do
      it "execute #{build_type} with specified configuration and other default options" do
        args = []
        args << "Project1" if build_project_task?(build_type)
        args << "Debug"
        Rake::Task[build_type].invoke(*args)

        expect(@options).to include("/p:Configuration=Debug")
        expect(@options).to include("/p:Platform=Win32")
        if rebuild_task?(build_type)
          expect(@options).to include("/t:Rebuild")
        end
      end
    end

    context "with platform option that value is 'Win64'" do
      it "execute #{build_type} with specified platform and other default options" do
        args = []
        args << "Project1" if build_type.end_with?("_project")
        args << "Release"
        args << "Win64"
        Rake::Task[build_type].invoke(*args)

        expect(@options).to include("/p:Configuration=Release")
        expect(@options).to include("/p:Platform=Win64")
        if rebuild_task?(build_type)
          expect(@options).to include("/t:Rebuild")
        end
      end
    end
  end
end


