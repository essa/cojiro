module CojiroRequestStubs

  def fixture_path
    File.join(Rails.root, "spec", "fixtures")
  end

  def fixture(file)
    File.open(File.expand_path(fixture_path + '/' + file))
  end

  def load_request_stubs
    stub_request(:get, "http://a1.twimg.com/profile_images/1234567/csasaki.png").to_return(:status => 200, :body => fixture("csasaki.png"), :headers => {})
  end
end
