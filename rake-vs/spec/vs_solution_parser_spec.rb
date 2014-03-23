# coding: utf-8
require 'spec_helper'
require File.expand_path('../../lib/vs_solution_parser', __FILE__)

module RakeVs
  describe 'VsSolutionParser' do
    context "with single project" do
      before do
        @parser = VsSolutionParser.new
        contents = "Microsoft Visual Studio Solution File, Format Version 12.00
# Visual Studio Express 2013 for Windows Desktop
VisualStudioVersion = 12.0.21005.1
MinimumVisualStudioVersion = 10.0.40219.1
Project(\"{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}\") = \"Project1\", \"Project1\\Project1.vcxproj\", \"{4A35A8F6-601B-4C6A-B7B5-211A29E7448D}\"
EndProject
Global
	GlobalSection(SolutionConfigurationPlatforms) = preSolution
		Debug|Win32 = Debug|Win32
		Release|Win32 = Release|Win32
	EndGlobalSection
	GlobalSection(ProjectConfigurationPlatforms) = postSolution
		{4A35A8F6-601B-4C6A-B7B5-211A29E7448D}.Debug|Win32.ActiveCfg = Debug|Win32
		{4A35A8F6-601B-4C6A-B7B5-211A29E7448D}.Debug|Win32.Build.0 = Debug|Win32
		{4A35A8F6-601B-4C6A-B7B5-211A29E7448D}.Release|Win32.ActiveCfg = Release|Win32
		{4A35A8F6-601B-4C6A-B7B5-211A29E7448D}.Release|Win32.Build.0 = Release|Win32
	EndGlobalSection
	GlobalSection(SolutionProperties) = preSolution
		HideSolutionNode = FALSE
	EndGlobalSection
EndGlobal"
      @projects = @parser.parse_project(contents)
      @project = @projects[0]
      end

      it 'parses one project definition' do
        expect(@projects.size).to eq(1)
      end

      it 'parses a project name' do
        expect(@project[:name]).to eq('Project1')
      end

      it 'parses a project path' do
        expect(@project[:path]).to eq('Project1\\Project1.vcxproj')
      end
    end
  end
end
