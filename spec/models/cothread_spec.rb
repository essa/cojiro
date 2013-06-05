require 'spec_helper'
require 'timecop'
require 'shoulda-matchers'

describe Cothread do
  before do
    I18n.locale = 'en'
  end

  describe 'associations' do
    it { should have_many(:comments) }
    it { should have_many(:links).through(:comments) }
  end

  describe "validation with factory" do
    before do
      @cothread = FactoryGirl.build(:cothread)
    end

    subject { @cothread }

    it "has a valid factory" do
      should be_valid
    end

    it "is invalid without a title in source locale" do
      # need to switch to other locale to make sure we are validating
      # presence of the title in the source locale explicitly
      I18n.with_locale(:fr) do
        subject.source_locale = 'en'
        subject.title_translations = { :en => "" }
        should_not be_valid
      end
    end

    it 'is valid with a title in source locale' do
      Globalize.with_locale(:ja) do
        FactoryGirl.create(:cothread, :source_locale => 'ja', :title => 'title').should be_valid
      end
    end

    it "is valid without a title in other locale" do
      Globalize.with_locale(:ja) do
        subject.title = ""
        should be_valid
      end
    end

    it "is invalid without a user" do
      subject.user = nil
      should_not be_valid
    end

  end

  describe "default values" do
    before do
      @cothread = FactoryGirl.create(:cothread)
    end

    it "sets default source language" do
      @cothread.source_locale = nil
      @cothread.save
      @cothread.source_locale.should == "en"
    end

  end

  describe ".new" do
    before do
      attr = { "title" =>  { "en" => "a title in English",
                             "ja" =>  "a title in Japanese" } }
      @cothread = Cothread.new(attr)
    end

    it "assigns translated attributes defined as JSON objects" do
      Globalize.with_locale(:en) { @cothread.title.should == "a title in English" }
      Globalize.with_locale(:ja) { @cothread.title.should == "a title in Japanese" }
    end
  end

  describe "#update_attributes" do
    before do
      @attr = { "title" => { "fr" => "a new title in French" } }
      @cothread = FactoryGirl.create(:cothread)
    end

    it "replaces/adds translations based on values in JSON object" do
      Globalize.with_locale(:fr) { @cothread.title = "a title in French" }
      @cothread.update_attributes(@attr)
      Globalize.with_locale(:fr) { @cothread.title.should == "a new title in French" }
    end

    it "leaves existing translations as is" do
      Globalize.with_locale(:fr) { @cothread.title = "a title in French" }
      Globalize.with_locale(:en) { @cothread.title = "a title in English" }
      @cothread.update_attributes(@attr)
      Globalize.with_locale(:en) { @cothread.title.should == "a title in English" }
    end

    pending "assigns non-translated attributes with values in JSON object"

    it "ignores nil attributes" do
      expect { @cothread.update_attributes(nil) }.not_to raise_error
    end

    it "does not assign nil-valued translated attributes" do
      Globalize.with_locale(:fr) { @cothread.summary = "a summary in French" }
      expect { @cothread.update_attributes("summary" => nil) }.not_to raise_error
      Globalize.with_locale(:fr) { @cothread.summary.should == "a summary in French" }
    end
  end

  describe "locale helper methods" do
    let!(:model) { FactoryGirl.create(:cothread) }

    describe "title" do
      it_behaves_like "attribute with locale methods", 'title'
    end

    describe "summary" do
      it_behaves_like "attribute with locale methods", 'summary'
    end
  end

  describe "#to_json" do
    before do
      Timecop.freeze(Time.utc(2002,7,20,12,20)) do
        @cothread = FactoryGirl.build(:cothread, user: FactoryGirl.create(:csasaki))
        Globalize.with_locale(:fr) do
          @cothread.title = "title in French"
          @cothread.summary = "summary in French"
        end
        @cothread.save
      end
      @cothread_json = @cothread.to_json
    end

    it "has an id" do
      JSON(@cothread_json)["id"].should be
    end

    it "has titles in all locales" do
      JSON(@cothread_json)["title"].should ==
        { "en" => @cothread.title, "fr" => "title in French" }
    end

    it "has summaries in all locales" do
      JSON(@cothread_json)["summary"].should ==
        { "en" => @cothread.summary, "fr" => "summary in French" }
    end

    it "has created_at and updated_at timestamps" do
      JSON(@cothread_json)["created_at"].should == "2002-07-20T12:20:00Z"
      JSON(@cothread_json)["updated_at"].should == "2002-07-20T12:20:00Z"
    end

    it "has a source locale" do
      JSON(@cothread_json)["source_locale"].should be
    end

    it "includes user" do
      JSON(@cothread_json)["user"].should be
      JSON(@cothread_json)["user"]["name"].should be
      JSON(@cothread_json)["user"]["fullname"].should be
      JSON(@cothread_json)["user"]["location"].should be
      JSON(@cothread_json)["user"]["profile"].should be
      JSON(@cothread_json)["user"]["avatar_url"].should be
      JSON(@cothread_json)["user"]["avatar_mini_url"].should be
    end

    it "does not include any other attributes" do
      JSON(@cothread_json).keys.delete_if { |k|
        [ "id",
          "title",
          "title_in_source_locale",
          "summary",
          "summary_in_source_locale",
          "created_at",
          "updated_at",
          "source_locale",
          "user"
        ].include?(k)
      }.should be_empty
    end
  end

  describe '#as_json' do
    it 'does not return nil translations' do
      Globalize.with_locale(:ja) do
        @cothread = FactoryGirl.build(:cothread, user: FactoryGirl.create(:csasaki))
      end
      @cothread.as_json[:title].should have_key('ja')
      @cothread.as_json[:title].should_not have_key('en')
    end
  end

end
