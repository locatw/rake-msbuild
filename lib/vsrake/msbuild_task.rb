require 'rake'
require File.expand_path('../context', __FILE__)

module VSRake
  class MSBuildTask
    attr_reader :context

    def initialize
      super
      @context = Context.new
    end

    def generate_build_tasks
      generate_build_task
    end

    private

    def generate_build_task
      Rake::Task.define_task(:build, [:configuration, :platform]) do |t, args|
        register_config_option(args.to_hash, "Release")
        register_platform_option(args.to_hash, "Win32")
        run_msbuild
      end
    end

    def register_config_option(build_args, default)
      param = default
      if build_args.has_key?(:configuration)
        param = build_args[:configuration]
      end
      @context.options << "/p:Configuration=#{param}"
    end
    
    def register_platform_option(build_args, default)
      param = default
      if build_args.has_key?(:platform)
        param = build_args[:platform]
      end
      @context.options << "/p:Platform=#{param}"
    end

    def run_msbuild
      msbuild = @context.exe
      options = @context.options.join(' ')
      solution = @context.solution

      sh "#{msbuild} #{options} #{solution} | nkf -w"
    end
  end
end
