require 'spec_helper'

describe Cothread do
  before do
    I18n.locale = 'en'
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
      subject.title = ""
      should_not be_valid
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
      @cothread.source_language = nil
      @cothread.save
      @cothread.source_language.should == "en"
    end

  end

  describe "#to_json" do
    before do
      Timecop.freeze(Time.utc(2002,7,20,12,20)) do
        @cothread = FactoryGirl.create(:cothread, user: FactoryGirl.create(:csasaki))
      end
      @cothread_json = @cothread.to_json
    end

    it "has an id" do
      JSON(@cothread_json)["id"].should be
    end

    it "has a title" do
      JSON(@cothread_json)["title"].should be
    end

    it "has a summary" do
      JSON(@cothread_json)["summary"].should be
    end

    it "has created_at and updated_at timestamps" do
      JSON(@cothread_json)["created_at"].should == "2002-07-20T12:20:00Z"
      JSON(@cothread_json)["updated_at"].should == "2002-07-20T12:20:00Z"
    end

    it "has a source language" do
      JSON(@cothread_json)["source_language"].should be
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
          "summary",
          "created_at",
          "updated_at",
          "source_language",
          "user"
        ].include?(k)
      }.should be_empty
    end

  end

end
