require_relative 'fixture_helpers'

module CojiroRequestStubs
  include FixtureHelpers

  def load_request_stubs

    # for omniauth
    stub_request(:get, "http://example.com/user.png").to_return(:status => 200, :body => fixture("user.png"), :headers => {})
    stub_request(:get, "http://example.com/alice.png").to_return(:status => 200, :body => fixture("alice.png"), :headers => {})
    stub_request(:get, "http://example.com/bob.png").to_return(:status => 200, :body => fixture("bob.png"), :headers => {})
    stub_request(:get, "http://example.com/csasaki.png").to_return(:status => 200, :body => fixture("csasaki.png"), :headers => {})

    # for link urls
    stub_request(:get, 'http://www.mywebsite.com').to_return(:status => 200)
    stub_request(:get, 'http://www.foo.com').to_return(:status => 200)

    # catch-all if no VCR cassette is in use -- to avoid an actual call to the API
    stub_request(:get, /#{Regexp.quote("http://api.embed.ly/1/oembed")}.*/).to_return(fixture('embedly_response.json'))
  end
end
