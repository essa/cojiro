# encoding: utf-8
require 'spec_helper'

describe 'New Cothread', :js => true do
  before do
    OmniAuthHelpers::add_twitter_mock('12345',
                                      "Cojiro Sasaki",
                                      "csasaki")
    twitter_sign_in
  end

  context 'English locale' do
    before do
      visit '/en/threads/new'
      page.should have_css('#content')
    end

    pending "displays form text in English" do

      # page title
      within :css, 'h1' do
        page.should have_content "Start a thread"
      end

      # labels
      within :css, 'form' do
        page.should have_content "Title"
        page.should have_content "Summary"
      end
      within :css, '.form-actions' do
        page.should have_content "Create thread"
        page.should have_content "Cancel"
      end

    end

    pending "displays validation messages in English" do
      within :css, '.form-actions' do
        find('button').click
      end
      within :css, 'form' do
        page.should have_content "can't be blank"
      end
      within :css, '#flash_error' do
        page.should have_content "There were problems with the following fields:"
      end
    end

    pending "displays success message in English" do
      fill_in 'title', :with => "abc"
      within :css, '.form-actions' do
        find('button').click
      end
      page.should have_content "Thread successfully created."
    end

  end

  context 'Japanese locale' do
    before do
      visit '/ja/threads/new'
    end

    pending "displays form text in Japanese" do

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

    end

    pending "displays validation messages in Japanese" do
      within :css, '.form-actions' do
        find('button').click
      end
      within :css, 'form' do
        page.should have_content "を入力してください。"
      end
      within :css, '#flash_error' do
        page.should have_content "次の項目を確認してください。"
      end
    end

    pending "displays success message in Japanese" do
      fill_in 'title', :with => "abc"
      within :css, '.form-actions' do
        find('button').click
      end
      page.should have_content "スレッドは作成されました。"
    end

  end
end
