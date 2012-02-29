require 'spec_helper'

describe '/layouts/application' do

  # to make sure both logged-in/logged-out test check for
  # same link text(s)
  before { @start_a_thread = "Start a thread" }

  context "English locale" do
    before { I18n.locale = Globalize.locale = :en }

    context "logged-out user" do
      before { view.stub(:logged_in?) { false } }

      describe "create thread link" do
        it "should not render the create thread button" do
          render
          rendered.should_not have_link(@start_a_thread)
        end
      end
    end

    context "logged-in user" do
      before do
        view.stub(:logged_in?) { true } 
        assign(:current_user, Factory(:user))
      end

      describe "create thread link" do
        it "should render the create thread button" do
          render
          rendered.should have_link(@start_a_thread)
        end
      end
    end
  end
end
