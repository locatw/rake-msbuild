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

describe "generetaed task named 'build'" do
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
    
    @options = @build_task.context.options
  end

  context "with no arguments" do
    it "execute build with default options" do
      Rake::Task['build'].invoke()

      expect(@options).to include("/p:Configuration=Release")
      expect(@options).to include("/p:Platform=Win32")
    end
  end

  context "with configuration option that value is 'Debug'" do
    it "execute build with specified configuration and other default options" do
      Rake::Task['build'].invoke('Debug')

      expect(@options).to include("/p:Configuration=Debug")
      expect(@options).to include("/p:Platform=Win32")
    end
  end

  context "with platform option that value is 'Win64'" do
    it "execute build with specified platform and other default options" do
      Rake::Task['build'].invoke('Release', 'Win64')

      expect(@options).to include("/p:Configuration=Release")
      expect(@options).to include("/p:Platform=Win64")
    end
  end
end
