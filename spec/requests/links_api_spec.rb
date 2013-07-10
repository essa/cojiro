require 'spec_helper'

describe 'Links API' do
  use_vcr_cassette('what_is_crossfit')

  #TODO: add more API specs, this is just a minimum to make sure URL passed in through
  # query string is correctly parsed (with loosed constraint in rails route) and
  # parsed heuriscially (e.g. adding 'http://') to get the canonical url for the new link
  describe 'GET /en/links/<id>.json' do
    context 'record with id = <id> exists' do
      let(:link) { FactoryGirl.create(:link, url: 'youtu.be/tzD9BkXGJ1M') }
      let(:json) { JSON(response.body) }
      before { get "/en/links/#{URI.decode_www_form_component(link.url)}", :format => :json }

      it 'returns with correct response code' do
        response.response_code.should == 200
      end

      it 'returns link with normalized url' do
        json.should include('url' => 'http://youtu.be/tzD9BkXGJ1M')
      end
    end
  end
end
