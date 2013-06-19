require 'spec_helper'

describe User do
  before do
    I18n.locale = 'en'
  end

  describe "validation with factory" do
    before do
      FactoryGirl.create(:alice)
      @user = FactoryGirl.build(:user)
    end

    subject { @user }

    it "is valid created by factory" do
      should be_valid
    end

    it "is invalid without a name" do
      subject.name = ""
      should_not be_valid
    end

    it "is invalid with a duplicate name" do
      subject.name = "alice"
      should_not be_valid
    end

    it "is invalid without a fullname" do
      subject.fullname = ""
      should_not be_valid
    end

    it "is invalid without an avatar" do
      subject.remove_avatar!
      should_not be_valid
    end

  end

  describe ".new_from_hash" do

    hash = {
      "provider"=>"twitter",
      "uid"=>"4138021",
      "info"=> { "name" => "Cojiro Sasaki",
        "nickname" => "csasaki",
        "description" => "I like dicing blue chickens.",
        "location" => "Fukui",
        "image" => "http://a1.twimg.com/profile_images/1234567/csasaki_normal.png" }
    }

    subject { User.new_from_hash(hash) }

    its(:name) { should == "csasaki" }
    its(:fullname) { should == "Cojiro Sasaki" }
    its(:location) { should == "Fukui" }
    its(:profile) { should == "I like dicing blue chickens." }

    it "removes '_normal' from filename in url to get image in original size" do
      subject.remote_avatar_url.should == "http://a1.twimg.com/profile_images/1234567/csasaki.png"
    end

  end

  describe "#to_json" do

    before do
      @user = FactoryGirl.create(:csasaki)
      @user_json = @user.to_json
    end

    it "has an id" do
      JSON(@user_json)["id"].should be
    end

    it "has a name" do
      JSON(@user_json)["name"].should be
    end

    it "has a fullname" do
      JSON(@user_json)["fullname"].should be
    end

    it "has a location" do
      JSON(@user_json)["location"].should be
    end

    it "has a profile" do
      JSON(@user_json)["profile"].should be
    end

    it "has an avatar url (original size)" do
      JSON(@user_json)["avatar_url"].should be
    end

    it "has an avatar url (mini size)" do
      JSON(@user_json)["avatar_mini_url"].should be
    end

    it "does not include any other attributes" do
      JSON(@user_json).keys.delete_if { |k|
        [ "id",
          "name",
          "fullname",
          "location",
          "profile",
          "avatar_url",
          "avatar_mini_url"
        ].include?(k)
      }.should be_empty
    end

  end

  describe '#to_param' do
    let(:user) { FactoryGirl.create(:alice).to_param }
    it 'returns the user name' do
      user.to_param.should == 'alice'
    end
  end
end
