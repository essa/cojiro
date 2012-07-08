require 'spec_helper'

describe 'Cothreads API' do
  before do
    @alice = FactoryGirl.create(:alice)
    @bob = FactoryGirl.create(:bob)

    Timecop.freeze(Time.utc(2002,7,20,12,20)) do
      @cothread1 = FactoryGirl.create(:cothread, :title => "An old post", :summary => "summary 1", :source_language => "ja", :user => @alice)
    end
    Timecop.freeze(Time.utc(2012,7,20,12,20)) do
      @cothread2 = FactoryGirl.create(:cothread, :title => "A very recent post", :summary => "summary 3", :source_language => "ja", :user => @alice)
    end
    Timecop.freeze(Time.utc(2005,7,20,12,20)) do
      @cothread3 = FactoryGirl.create(:cothread, :title => "A somewhat recent post", :summary => "summary 2", :source_language => "en", :user => @bob)
    end
  end

  describe 'GET /en/threads.json' do
    before do
      get '/en/threads', :format => :json
      @json = JSON(response.body)
    end

    it "returns a list of cothreads in reverse chronological order" do
      @json[0].should include(
        "title" => "A very recent post",
        "summary" => "summary 3",
        "source_language" => "ja",
        "created_at" => 1342786800,
        "updated_at" => 1342786800,
      )
      @json[1].should include(
        "title" => "A somewhat recent post",
        "summary" => "summary 2",
        "source_language" => "en",
        "created_at" => 1121862000,
        "updated_at" => 1121862000
      )
      @json[2].should include(
        "title" => "An old post",
        "summary" => "summary 1",
        "source_language" => "ja",
        "created_at" => 1027167600,
        "updated_at" => 1027167600
      )
    end

    it "includes user information for threads" do
      @json[0]["user"].should include(
        "name" => "alice",
        "fullname" => "Alice in Wonderland"
      )
      @json[1]["user"].should include(
        "name" => "bob",
        "fullname" => "Bob the Builder"
      )
      @json[2]["user"].should include(
        "name" => "alice",
        "fullname" => "Alice in Wonderland"
      )
    end

  end

  describe 'GET /en/threads/<id>.json' do

    context 'record with id = <id> exists' do
      before do
        get "/en/threads/#{@cothread1.id}", :format => :json
        @json = JSON(response.body)
      end

      it "returns the cothread with id = <id>" do
        @json.should include(
          "title" => "An old post",
          "summary" => "summary 1",
          "source_language" => "ja",
          "created_at" => 1027167600,
          "updated_at" => 1027167600
        )
        @json["user"].should include(
          "name" => "alice",
          "fullname" => "Alice in Wonderland"
        )
      end
    end

    context 'record with id = <id> does not exist' do

      it "returns not found error" do

      end
    end
  end

end
