require 'spec_helper'

describe User do
  before do
    I18n.locale = 'en'
  end

  describe "validation with factory" do
    before do
      @user = FactoryGirl.create(:user)
      FactoryGirl.create(:user, :name => "alice")
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

end
