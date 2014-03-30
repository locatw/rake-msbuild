# coding: utf-8
require 'spec_helper'
require File.expand_path('../../../lib/vsrake/vs_solution', __FILE__)
require File.expand_path('../../../lib/vsrake/vs_solution_parser', __FILE__)

module VSRake
  describe 'VsSolution' do
    before do
      @parser_double = double("solution_parser")

      @vss = VsSolution.new
      @vss.stub(:create_parser).and_return(@parser_double)

      @project1 = {}
      @project1[:name] = 'Project1'
      @project1[:path] = 'ProjectPath1'
      @project1[:guid] = 'AAA'
      @project1[:type] = :cpp_project

      @project2 = {}
      @project2[:name] = 'Project2'
      @project2[:path] = 'ProjectPath2'
      @project2[:guid] = 'BBB'
      @project2[:type] = :cpp_project
    end

    context 'that loaded a solution file with single project' do
      before do
        @parser_double.should_receive(:parse)
                      .with("dummy_path")
                      .and_return([@project1])
        @vss.load("dummy_path")
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
        expect(project.path).to eq('ProjectPath1')
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

    context 'that loaded a solution file with two project' do
      before do
        @parser_double.should_receive(:parse)
                      .with("dummy_path")
                      .and_return([@project1, @project2])
        @vss.load("dummy_path")
      end

      it 'has two project' do
        expect(@vss.projects.size).to eq(2)
      end

      it 'has a project that has correct properties at first' do
        project = @vss.projects[0]
        expect(project.name).to eq('Project1')
        expect(project.path).to eq('ProjectPath1')
        expect(project.guid).to eq('AAA')
        expect(project.type).to eq(:cpp_project)
      end

      it 'has a project that has correct properties at second' do
        project = @vss.projects[1]
        expect(project.name).to eq('Project2')
        expect(project.path).to eq('ProjectPath2')
        expect(project.guid).to eq('BBB')
        expect(project.type).to eq(:cpp_project)
      end
    end
  end
end
