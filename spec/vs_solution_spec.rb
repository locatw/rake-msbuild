# coding: utf-8
require 'spec_helper'
require File.expand_path('../../lib/vs_solution', __FILE__)
require File.expand_path('../../lib/vs_solution_parser', __FILE__)

module RakeMSBuild
  describe 'VsSolution' do
    before do
      @vss = VsSolution.new
    end

    context 'that loaded a solution file with single project' do
      before do
        @vss.stub(:parse) {
          project = {}
          project[:name] = 'Project1'
          project[:path] = 'ProjectPath'
          project[:guid] = 'AAA'
          project[:type] = :cpp_project

          [project]
        }
        @vss.load(File.expand_path("../data/SingleProjectSolution.sln", __FILE__))
      end

      it 'has one project' do
        expect(@vss.projects.size).to eq(1)
      end

      it 'has a project that has correct name' do
        project = @vss.projects[0]
        expect(project.name).to eq('Project1')
      end

      it 'has a project that has correct path' do
        project = @vss.projects[0]
        expect(project.path).to eq('ProjectPath')
      end

      it 'has a project that has correct guid' do
        project = @vss.projects[0]
        expect(project.guid).to eq('AAA')
      end

      it 'has a project that has correct type' do
        project = @vss.projects[0]
        expect(project.type).to eq(:cpp_project)
      end
    end
  end
end
