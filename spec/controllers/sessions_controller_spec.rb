require 'spec_helper'

describe SessionsController do
  include MockModels

  before do
    OmniAuthHelpers.add_twitter_mock("12345","Cojiro Sasaki","csasaki")
  end

  describe "logout" do

    before do
      visit '/auth/twitter'
      post :destroy
    end

    it "unsets the session cookie" do
      session[:user].should be_nil
    end

    it "does not set @current_user" do
      @current_user.should be_nil
    end

    it "redirects to the homepage" do
      response.should redirect_to(homepage_path)
    end

  end

  describe "callback" do

    before do
      auth = mock_authorization
      user = mock_user(:name => "csasaki")
      Authorization.stub(:find_from_hash) { auth }
      auth.should_receive(:user).and_return(user)
    end

    it "should assign @auth" do
      get :callback
      assigns(:auth).should be(@mock_authorization)
    end

    it "should set user session cookie" do
      get :callback
      session[:user].should == "csasaki"
    end

    it "redirects to the homepage" do
      get :callback
      response.should redirect_to(homepage_path)
    end

  end

end
