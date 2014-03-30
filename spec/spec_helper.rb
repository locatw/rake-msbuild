def make_solution_path(solution_name)
  File.expand_path("../data", __FILE__) + "/" + solution_name + ".sln"
end

