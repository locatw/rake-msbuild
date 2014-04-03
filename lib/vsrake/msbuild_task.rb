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

    def generate_build_tasks
      generate_build_task
      generate_build_project_task
      generate_rebuild_task
      generate_rebuild_project_task
      generate_clean_task
    end

    private

    def generate_build_task
      Rake.application.in_namespace("vs") do |ns|
        Rake::Task.define_task(:build, [:configuration, :platform]) do |t, args|
          args = args.to_hash
          register_config_option(args)
          register_platform_option(args)
          execute_msbuild
        end
      end
    end

    def generate_build_project_task
      Rake.application.in_namespace("vs") do |ns|
        Rake::Task.define_task(:build_project, [:name, :configuration, :platform]) do |t, args|
          args = args.to_hash

          project = load_project(args)

          register_project(project)
          register_config_option(args)
          register_platform_option(args)

          execute_msbuild
        end
      end
    end

    def generate_rebuild_task
      Rake.application.in_namespace("vs") do |ns|
        Rake::Task.define_task(:rebuild, [:configuration, :platform]) do |t, args|
          args = args.to_hash
          register_target_option("Rebuild")
          register_config_option(args)
          register_platform_option(args)
          execute_msbuild
        end
      end
    end

    def generate_rebuild_project_task
      Rake.application.in_namespace("vs") do |ns|
        Rake::Task.define_task(
          :rebuild_project,
          [:name, :configuration, :platform]
        ) do |t, args|
          args = args.to_hash

          project = load_project(args)
          
          register_target_option("Rebuild")
          register_project(project)
          register_config_option(args)
          register_platform_option(args)

          execute_msbuild
        end
      end
    end

    def generate_clean_task
      Rake.application.in_namespace("vs") do |ns|
        Rake::Task.define_task(:clean) do |t|
          register_target_option("Clean")

          execute_msbuild
        end
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

    def register_project(project)
      proj_filepath = File.dirname(@context.solution)
      proj_filepath += "/" + project.path

      @context.solution = proj_filepath
    end
  end
end
