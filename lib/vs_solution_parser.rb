module RakeVs
  class VsSolutionParser

    def parse_project(contents)
      projects = []

      proj_def = extract_project_defs(contents)
      type, params = split_project_def(proj_def)
      name, path, guid = split_project_params(params)
      
      projects << {:type => type, :name => name, :path => path, :guid => guid} 

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
      type_def, params = project_def.split("=", 2)
      type_guid = extract_project_type(type_def)

      type = case type_guid
             when '8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942' then :cpp_project
             else
             raise "unknown project type"
             end

      return [type, params]
    end

    def extract_project_type(project_type_def)
      match_data = project_type_def.match(/Project\(\"\{(.*)\}\"\)/)
      raise "cannot extract project type" if match_data.nil?
      match_data[1]
    end

    def split_project_params(project_params_def)
      # カンマと改行で区切る
      name, path, guid = project_params_def.split(/[,\r\n]/, 4)
      strip_and_remove_quote!(name)
      strip_and_remove_quote!(path)
      strip_and_remove_quote!(guid)
      guid.delete!("{}")
      return [name, path, guid]
    end

    def strip_and_remove_quote!(s)
      s.strip!.delete!('"')
    end
  end
end
