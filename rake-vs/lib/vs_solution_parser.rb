module RakeVs
  class VsSolutionParser

    def parse_project(contents)
      projects = []

      proj_def = extract_project_defs(contents)
      proj_type, proj_params = split_project_def(proj_def)
      proj_name, proj_path, proj_guid = split_project_params(proj_params)
      
      proj = {}
      proj[:name] = proj_name
      proj[:path] = proj_path
      proj[:guid] = proj_guid
      projects << proj 

      projects
    end

    private

    def extract_project_defs(contents)
      # 改行を含むので/m修飾子が必要
      match_data = contents.match(/Project.+EndProject/m)
      raise "project definition not found" if match_data.nil?
      match_data[0]
    end

    def split_project_def(project_def)
      type, params = project_def.split("=", 2)
      return [type, params]
    end

    def split_project_params(project_params_def)
      # カンマと改行で区切る
      name, path, guid = project_params_def.split(/[,\r\n]/, 4)
      strip_and_remove_quote(name)
      strip_and_remove_quote(path)
      strip_and_remove_quote(guid)
      guid.delete!("{}")
      return [name, path, guid]
    end

    def strip_and_remove_quote(s)
      s.strip!.delete!('"')
    end
  end
end
