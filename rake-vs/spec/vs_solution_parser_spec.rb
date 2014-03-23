# coding: utf-8
require 'spec_helper'
require File.expand_path('../../lib/vs_solution_parser', __FILE__)

module RakeVs
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
  end
end
