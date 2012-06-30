require 'spec_helper'

describe 'Cothreads API' do
  before do
    @alice = FactoryGirl.create(:alice)
    @bob = FactoryGirl.create(:bob)
  end

  describe 'GET "index.json"' do
    before do
      Timecop.freeze(Time.local(2002,7,20,12,20))
      cothread = FactoryGirl.create(:cothread, :title => "An old post", :summary => "summary 1", :source_language => "ja", :user => @alice)
      Timecop.freeze(Time.local(2012,7,20,12,20))
      cothread = FactoryGirl.create(:cothread, :title => "A very recent post", :summary => "summary 3", :source_language => "ja", :user => @alice)
      Timecop.freeze(Time.local(2005,7,20,12,20))
      cothread = FactoryGirl.create(:cothread, :title => "A somewhat recent post", :summary => "summary 2", :source_language => "en", :user => @bob)

      get '/en/threads', :format => :json
      @json = JSON(response.body)
    end

    it "returns a list of cothreads in reverse chronological order" do
      @json[0].should include(
        "title" => "A very recent post",
        "summary" => "summary 3",
        "source_language" => "ja",
        "created_at" => 1342754400,
        "updated_at" => 1342754400,
      )
      @json[1].should include(
        "title" => "A somewhat recent post",
        "summary" => "summary 2",
        "source_language" => "en",
        "created_at" => 1121829600,
        "updated_at" => 1121829600
      )
      @json[2].should include(
        "title" => "An old post",
        "summary" => "summary 1",
        "source_language" => "ja",
        "created_at" => 1027135200,
        "updated_at" => 1027135200
      )
    end

    it "includes user information for threads" do
      @json[0]["user"].should include(
        "name" => "alice",
        "fullname" => "Alice"
      )
      @json[1]["user"].should include(
        "name" => "bob",
        "fullname" => "Bob"
      )
      @json[2]["user"].should include(
        "name" => "alice",
        "fullname" => "Alice"
      )
    end

  end

end
