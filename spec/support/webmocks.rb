require_relative 'fixture_helpers'

module CojiroRequestStubs
  include FixtureHelpers

  def load_request_stubs
    stub_request(:get, "http://example.com/user.png").to_return(:status => 200, :body => fixture("user.png"), :headers => {})
    stub_request(:get, "http://example.com/alice.png").to_return(:status => 200, :body => fixture("alice.png"), :headers => {})
    stub_request(:get, "http://example.com/bob.png").to_return(:status => 200, :body => fixture("bob.png"), :headers => {})
    stub_request(:get, "http://example.com/csasaki.png").to_return(:status => 200, :body => fixture("csasaki.png"), :headers => {})
  end
end
