def read_test_data(filename)
  filepath = File.expand_path("../data", __FILE__) + "\\" + filename
  raise "file not exists [#{filename}]" if not File.exists?(filepath)

  contents = ""
  File.open(filepath) do |f|
    f.read(nil, contents)
  end

  contents
end

