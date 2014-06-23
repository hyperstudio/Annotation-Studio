module FileHelpers
  def example_file_path(file_base_name)
    "spec/support/example_files/#{file_base_name}"
  end

  def example_file(file_base_name)
    File.open(example_file_path(file_base_name))
  end
end
