require 'spec_helper'

describe 'layouts/application' do

  # to make sure both logged-in/logged-out test check for
  # same link text(s)
  before do
    @start_a_thread = "Start a thread"
    @twitter_sign_in = "Sign in through Twitter"
  end

  context "English locale" do
    before { I18n.locale = Globalize.locale = :en }

    context "logged-out user" do
      before { view.stub(:logged_in?) { false } }

      it "does not render start a thread link" do
        render
        rendered.should_not have_link(@start_a_thread)
      end

      it "renders twitter sign-in link" do
        render
        rendered.should have_link(@twitter_sign_in)
      end

    end

    context "logged-in user" do
      before do
        view.stub(:logged_in?) { true } 
        assign(:current_user, FactoryGirl.create(:user))
      end

      it "renders start a thread link" do
        render
        rendered.should have_link(@start_a_thread)
      end

      it "does not render twitter sign-in link" do
        render
        rendered.should_not have_link(@twitter_sign_in)
      end

    end
  end
end
