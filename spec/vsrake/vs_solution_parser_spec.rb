# coding: utf-8
require 'spec_helper'
require File.expand_path('../../lib/vs_solution_parser', __FILE__)

module VSRake
  describe 'VsSolutionParser' do
    context "with single project" do
      before(:all) do
        @contents = read_test_data('SingleProjectSolution.sln')
      end

      before do
        @parser = VsSolutionParser.new
        @projects = @parser.parse_project(@contents)
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

      it 'parses a project GUID' do
        expect(@project[:guid]).to eq('4A35A8F6-601B-4C6A-B7B5-211A29E7448D')
      end

      it 'parses a project type' do
        expect(@project[:type]).to eq(:cpp_project)
      end
    end

    context 'with two projects' do
      before(:all) do
        @contents = read_test_data('TwoProjectSolution.sln')
      end

      before do
        @parser = VsSolutionParser.new
        @projects = @parser.parse_project(@contents)
      end

      it 'parses two project definition' do
        expect(@projects.size).to eq(2)
      end

      it 'parses first project' do
        @proj = @projects[0]
        expect(@proj[:name]).to eq('Project1')
        expect(@proj[:path]).to eq('Project1\\Project1.vcxproj')
        expect(@proj[:guid]).to eq('A59480EC-74D2-4F52-8977-659306B85DEC')
        expect(@proj[:type]).to eq(:cpp_project)
      end

      it 'parses second project' do
        @proj = @projects[1]
        expect(@proj[:name]).to eq('Project2')
        expect(@proj[:path]).to eq('Project2\\Project2.vcxproj')
        expect(@proj[:guid]).to eq('50A18D08-4508-4C00-9326-3A1465B893CE')
        expect(@proj[:type]).to eq(:cpp_project)
      end
    end
  end
end
