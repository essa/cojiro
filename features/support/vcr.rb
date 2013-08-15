# ref: http://stackoverflow.com/questions/8148168/using-vcr-with-cucumber-via-tags
# Rspec is configured separately, see spec/spec_helper.rb
VCR.configure do |c|
  c.cassette_library_dir = 'features/fixtures/vcr_cassettes'
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :webmock
  c.default_cassette_options = {
    :match_requests_on => [ :method, VCR.request_matchers.uri_without_param(:key)]
  }
  c.ignore_localhost = true
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
end
