# encoding: utf-8
require 'spec_helper'

describe 'Homepage', :js => true do
  before do
    FactoryGirl.create(:cothread,
                       user: FactoryGirl.create(:alice))
  end

  context 'logged-out' do

    context 'English locale' do

      it "displays intro text" do
        visit '/en'
        within :css, '#homepage .hero' do
          page.should have_content "Curating content from one language to another"
          page.should have_content "Cojiro is a platform that connects people with complementary skill sets to identify, group and convey stories in one language to a broader audience in another language."
          page.should have_link "Learn more."
        end
      end

      it "displays recent threads" do
        visit '/en'
        within :css, '#homepage .latest' do
          page.should have_content "Recent threads"
          page.should have_content "Please create an account or log in to contribute your expertise."
          page.should have_link "create an account"
          page.should have_link "log in"
          page.should have_content "Started by @alice"
        end
      end

    end

    context 'Japanese locale' do

      it "displays intro text in Japanese locale" do
        visit '/ja'
        within :css, '#homepage .hero' do
          page.should have_content "日本語のキャッチコピー"
          page.should have_content "日本語の説明文章"
          page.should have_link "詳しくはこちらへ"
        end
      end

      it "displays recent threads" do
        visit '/ja'
        within :css, '#homepage .latest' do
          page.should have_content '最新のスレッド'
          page.should have_content 'アカウントを登録するまたはログインしてください'
          page.should have_link 'アカウントを登録する'
          page.should have_link 'ログイン'
          page.should have_content "aliceが登録した"
        end
      end

    end

  end

end
