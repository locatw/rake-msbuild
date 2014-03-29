require File.expand_path('../context', __FILE__)
require File.expand_path('../msbuild_task', __FILE__)

module VSRake
  class << self
    def build_task
      @build_task ||= VSRake::MSBuildTask.new
    end

    def configure(&block)
      yield build_task.context
      @build_task.generate_build_tasks
    end
  end
end
