require 'spec_helper'

describe User do

  describe ".new_from_hash" do

    before do
      hash = { 
        "provider"=>"twitter", 
        "uid"=>"4138021", 
        "info"=> { "name" => "Cojiro Sasaki", 
          "nickname" => "csasaki",
          "description" => "I like dicing blue chickens.",
          "location" => "Fukui" }
      }
      @user = User.new_from_hash(hash)
    end

    subject { @user }

    its(:name) { should == "csasaki" }
    its(:fullname) { should == "Cojiro Sasaki" }
    its(:location) { should == "Fukui" }
    its(:profile) { should == "I like dicing blue chickens." }

  end

  describe "#as_json" do

    before do
      @user = FactoryGirl.create(:user)
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

    it "does not include any other attributes" do
      JSON(@user_json).keys.delete_if { |k|
        [ "id",
          "name",
          "fullname",
          "location",
          "profile",
        ].include?(k)
      }.should be_empty
    end

  end

end
