require 'spec_helper'

describe "Start a thread" do

  before do
    OmniAuthHelpers::add_twitter_mock('12345',
                                      "Cojiro Sasaki",
                                      "csasaki")
    visit '/auth/twitter'
  end

  context "English locale" do

    before { I18n.locale = 'en' }

    describe "cancel button" do

      it "redirects to homepage" do
        visit new_cothread_path
        click_on 'Cancel'
        page.should have_css("title", :text => "cojiro: home")
      end

    end

  end

end
