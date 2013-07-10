# encoding: utf-8
require 'spec_helper'

describe 'Links API' do
  use_vcr_cassette('google_maps_tokyo')

  #TODO: add more API specs, this is just a minimum to make sure URL passed in through
  # query string is correctly parsed (with loosed constraint in rails route) and
  # parsed heuriscially (e.g. adding 'http://') to get the canonical url for the new link
  describe 'GET /en/links/<id>.json' do
    context 'record with id = <id> exists' do
      let(:link) { FactoryGirl.create(:link, url: 'https://maps.google.com/maps?q=東京&hl=ja&ie=UTF8&sll=37.0625,-95.677068&sspn=37.188995,86.572266&hnear=日本,+東京都&t=m&z=10') }
      let(:json) { JSON(response.body) }
      before { get "/en/links/#{CGI.escape(link.url)}", :format => :json }

      it 'returns with correct response code' do
        response.response_code.should == 200
      end

      it 'returns link with normalized url' do
        json['url'].should == 'https://maps.google.com/maps?q=%E6%9D%B1%E4%BA%AC&hl=ja&ie=UTF8&sll=37.0625,-95.677068&sspn=37.188995,86.572266&hnear=%E6%97%A5%E6%9C%AC,+%E6%9D%B1%E4%BA%AC%E9%83%BD&t=m&z=10'
      end

      it 'returns embed data' do
        json.should have_key('embed_data')
        embed_data = json['embed_data']
        embed_data.should include('provider_name' => 'Google Maps')
        embed_data.should include('height' => 480)
        embed_data.should include('width' => 640)
      end
    end
  end
end
