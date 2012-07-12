# encoding: utf-8
require 'spec_helper'

describe 'New Cothread', :js => true do
  before do
    OmniAuthHelpers::add_twitter_mock('12345',
                                      "Cojiro Sasaki",
                                      "csasaki")
    visit '/auth/twitter'
  end

  context 'English locale' do

    it "displays form text in English" do
      visit '/en/threads/new'

      # labels
      within :css, 'form' do
        page.should have_content "Title"
        page.should have_content "Summary"
      end
      within :css, '.form-actions' do
        page.should have_content "Create thread"
        page.should have_content "Cancel"
      end

      # validation messages
      within :css, '.form-actions' do
        find('button').click
      end
      within :css, 'form' do
        page.should have_content "can't be blank"
      end

    end
  end

  context 'Japanese locale' do

    it "displays form text in Japanese" do
      visit '/ja/threads/new'

      # page title
      within :css, 'h1' do
        page.should have_content "スレッドを立てる"
      end

      # labels
      within :css, 'form' do
        page.should have_content "タイトル"
        page.should have_content "サマリ"
      end
      within :css, '.form-actions' do
        page.should have_content "登録する"
        page.should have_content "キャンセル"
      end

      # validation messages
      within :css, '.form-actions' do
        find('button').click
      end
      within :css, 'form' do
        page.should have_content "を入力してください。"
      end

    end

  end
end
