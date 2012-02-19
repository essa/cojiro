require 'spec_helper'

describe Authorization do

  context "generated by FactoryGirl" do
    subject { Factory(:authorization) }
    it { should be_valid }
  end

  describe "create_from_hash" do

    hash = { 
      "provider"=>"twitter", 
      "uid"=>"4138021", 
      "info"=> { "name" => "Cojiro Sasaki", 
        "nickname"=>"csasaki" }
    }

    subject { Authorization.create_from_hash!(hash) }
    it { should be_valid }
    its(:provider) { should == "twitter" }
    its(:uid) { should == "4138021" }

    it "should create a User from hash" do
      user = subject.user
      user.name.should == "csasaki"
      user.fullname.should == "Cojiro Sasaki"
    end

  end

end
