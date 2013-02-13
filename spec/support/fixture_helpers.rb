module FixtureHelpers
  def fixture_path
    File.join(Rails.root, "spec", "fixtures")
  end

  def fixture(file)
    File.open(File.expand_path(fixture_path + '/' + file))
  end
end
