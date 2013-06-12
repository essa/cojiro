require 'spec_helper'

describe "Twitter sign-in" do

  describe "sign in using Twitter for the first time" do

    before do
      User.count.should == 0
      OmniAuthHelpers::add_twitter_mock('12345',
                                        "Cojiro Sasaki",
                                        "csasaki")
      twitter_sign_in
    end

    it "saves all the information provided by Twitter" do
      User.count.should == 1
      user = User.first
      user.name.should == 'csasaki'
      user.fullname.should == 'Cojiro Sasaki'
      user.should have(1).authorizations
      user.authorizations.first.provider.should == 'twitter'
      user.authorizations.first.uid.should == '12345'
    end

  end

end
