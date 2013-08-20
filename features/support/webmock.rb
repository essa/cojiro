require 'webmock/cucumber'
require File.join(Rails.root, "spec", "support", "webmocks.rb")

WebMock.disable_net_connect!(:allow_localhost => true)

World(CojiroRequestStubs)

Before do
  load_request_stubs
  load_embedly_request_stub
end
