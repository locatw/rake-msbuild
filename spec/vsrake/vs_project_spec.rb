require 'spec_helper'
require File.expand_path('../../../lib/vsrake/vs_project', __FILE__)

module VSRake
  describe "VsProject" do
    context "when constructed with a path separator '/'" do
      it "returns a path with path separator '/'" do
        proj = VsProject.new("", "a/b/c.vcxproj", "", :cpp_project)
        expect(proj.path).to eq("a/b/c.vcxproj")
      end
    end

    context "when constructed with a path separator '\'" do
      it "returns a path with path separator '/'" do
        proj = VsProject.new("", "a\\b\\c.vcxproj", "", :cpp_project)
        expect(proj.path).to eq("a/b/c.vcxproj")
      end
    end
  end
end

