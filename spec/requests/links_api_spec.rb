# encoding: utf-8
require 'spec_helper'
require 'timecop'

describe 'Links API' do
  use_vcr_cassette('google_maps_tokyo')

  #TODO: add more API specs, this is just a minimum to make sure URL passed in through
  # query string is correctly parsed (with loosed constraint in rails route) and
  # parsed heuriscially (e.g. adding 'http://') to get the canonical url for the new link
  describe 'GET /en/links/<id>.json' do
    context 'record with id = <id> exists' do
      let(:link) { FactoryGirl.create(:link, url: 'https://maps.google.com/maps?q=東京&hl=ja&ie=UTF8&sll=37.0625,-95.677068&sspn=37.188995,86.572266&hnear=日本,+東京都&t=m&z=10') }
      before do
        Timecop.freeze(Time.utc(2008,8,20,12,20)) do
          get "/en/links/#{CGI.escape(link.url)}", :format => :json
        end
      end

      it 'returns with correct response code' do
        response.response_code.should == 200
      end

      describe 'json' do
        let(:json) { JSON(response.body) }
        subject { json }

        its(['url']) { should == 'https://maps.google.com/maps?q=%E6%9D%B1%E4%BA%AC&hl=ja&ie=UTF8&sll=37.0625,-95.677068&sspn=37.188995,86.572266&hnear=%E6%97%A5%E6%9C%AC,+%E6%9D%B1%E4%BA%AC%E9%83%BD&t=m&z=10' }
        its(['created_at']) { should == '2008-08-20T12:20:00Z' }
        its(['updated_at']) { should == '2008-08-20T12:20:00Z' }

        it 'returns embed data' do
          json.should have_key('oembed_data')
          oembed_data = json['oembed_data']
          oembed_data.should include('provider_name' => 'Google Maps')
          oembed_data.should include('height' => 480)
          oembed_data.should include('width' => 640)
        end

        its(['site_name']) { should == 'maps.google.com' }
        its(['favicon_url']) { should == 'https://maps.gstatic.com/favicon3.ico' }
      end
    end
  end
end
