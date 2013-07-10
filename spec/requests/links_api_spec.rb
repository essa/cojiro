# encoding: utf-8
require 'spec_helper'

describe 'Links API' do
  use_vcr_cassette('capoeira_wikipedia_ja')

  #TODO: add more API specs, this is just a minimum to make sure URL passed in through
  # query string is correctly parsed (with loosed constraint in rails route) and
  # parsed heuriscially (e.g. adding 'http://') to get the canonical url for the new link
  describe 'GET /en/links/<id>.json' do
    context 'record with id = <id> exists' do
      let(:link) { FactoryGirl.create(:link, url: 'ja.wikipedia.org/wiki/カポエイラ') }
      let(:json) { JSON(response.body) }
      before { get "/en/links/#{link.url}", :format => :json }

      it 'returns with correct response code' do
        response.response_code.should == 200
      end

      it 'returns link with normalized url' do
        json.should include('url' => 'http://ja.wikipedia.org/wiki/%E3%82%AB%E3%83%9D%E3%82%A8%E3%82%A4%E3%83%A9')
      end

      it 'returns embed data' do
        json.should have_key('embed_data')
        embed_data = json['embed_data']
        embed_data.should include('title' => 'カポエイラ')
        embed_data.should include('thumbnail_height' => 208)
        embed_data.should include('thumbnail_width' => 300)
      end
    end
  end
end
