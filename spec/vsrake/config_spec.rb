# coding: utf-8
require 'spec_helper'
require File.expand_path('../../../lib/vsrake/config', __FILE__)

include VSRake

module VSRake
  describe 'Config' do
    it 'is set up by calling config method' do
      VSRake::configure do |c|
        c.exe = 'msbuild.exe'
        c.solution = 'example.sln'
      end

      expect(VSRake.config.exe).to eq('msbuild.exe')
      expect(VSRake.config.solution).to eq('example.sln')
    end
  end
end
