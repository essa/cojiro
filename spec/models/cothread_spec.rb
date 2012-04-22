require 'spec_helper'

describe Cothread do
  before do
    I18n.locale = 'en'
  end

  describe "validation with factory" do
    before do
      @cothread = FactoryGirl.create(:cothread)
    end

    subject { @cothread }

    it "is valid when created by factory" do
      should be_valid
    end

    it "is invalid without a title" do
      subject.title = ""
      should_not be_valid
    end

    it "is invalid without a user" do
      subject.user = nil
      should_not be_valid
    end

    it "sets default source language" do
      subject.source_language = nil
      subject.save
      subject.source_language.should == :en
    end

  end

  describe "#as_json" do
    before do
      @cothread = FactoryGirl.create(:cothread)
      @cothread_json = @cothread.to_json
    end

    it "has a title" do
      JSON(@cothread_json)["title"].should be
    end

    it "has a summary" do
      JSON(@cothread_json)["summary"].should be
    end

    it "has created_at and updated_at timestamps" do
      JSON(@cothread_json)["created_at"].should be
      JSON(@cothread_json)["updated_at"].should be
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
    end

  end

end
