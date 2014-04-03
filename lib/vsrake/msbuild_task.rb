require 'rake'
require File.expand_path('../context', __FILE__)
require File.expand_path('../vs_solution', __FILE__)

module VSRake
  class MSBuildTask
    attr_accessor :context

    def initialize
      super
      @context = Context.new
    end

    def define_tasks
      Rake.application.in_namespace("vs") do |ns|
        define_build_task
        define_build_project_task
        define_rebuild_task
        define_rebuild_project_task
        define_clean_task
      end
    end

    private

    def define_build_task
      Rake::Task.define_task(:build, [:configuration, :platform]) do |t, args|
        execute_task(t.name, args, "Build")
      end
    end

    def define_build_project_task
      Rake::Task.define_task(:build_project, [:name, :configuration, :platform]) do |t, args|
        execute_task(t.name, args, "Build")
      end
    end

    def define_rebuild_task
      Rake::Task.define_task(:rebuild, [:configuration, :platform]) do |t, args|
        execute_task(t.name, args, "Rebuild")
      end
    end

    def define_rebuild_project_task
      Rake::Task.define_task(
        :rebuild_project,
        [:name, :configuration, :platform]
      ) do |t, args|
        execute_task(t.name, args, "Rebuild")
      end
    end

    def define_clean_task
      Rake::Task.define_task(:clean) do |t|
        execute_task(t.name, {}, "Clean")
      end
    end

    def execute_task(task_name, args, target)
      register_options(task_name, args, target)
      execute_msbuild
    end

    def register_options(task_name, args, target)
      args = args.to_hash

      register_target_option(target)
      if task_name != "vs:clean"
        register_project(args) if task_for_project?(task_name)
        register_config_option(args)
        register_platform_option(args)
      end
    end

    def register_target_option(target)
      @context.options << "/t:#{target}"
    end

    def register_config_option(build_args)
      param = "Release"
      if build_args.has_key?(:configuration)
        param = build_args[:configuration]
      end
      @context.options << "/p:Configuration=#{param}"
    end
    
    def register_platform_option(build_args)
      param = "Win32"
      if build_args.has_key?(:platform)
        param = build_args[:platform]
      end
      @context.options << "/p:Platform=#{param}"
    end

    def execute_msbuild
      msbuild = @context.exe
      options = @context.options.join(' ')
      solution = @context.solution

      command = "#{msbuild} #{options} #{solution} | nkf -w"

      execute_msbuild_command(command)
    end

    def execute_msbuild_command(command)
      Rake::FileUtilsExt.sh command
    end 

    def load_project(args)
      raise "project name is not specified" unless args.has_key?(:name)
      
      project = find_project_by_name(args[:name])
      raise "specified project is not found" if project.nil?

      project
    end

    def find_project_by_name(project_name)
      vss = VsSolution.new
      vss.load(@context.solution)
      vss.project(project_name)
    end

    def register_project(args)
      project = load_project(args)

      proj_filepath = File.dirname(@context.solution)
      proj_filepath += "/" + project.path

      @context.solution = proj_filepath
    end

    def task_for_project?(task_name)
      task_name.end_with?("_project")
    end
  end
end
