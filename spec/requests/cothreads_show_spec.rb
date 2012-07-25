# encoding: utf-8
require 'spec_helper'

describe 'Cothread page', :js => true do
  before do
    I18n.with_locale(:en) do
      @thread = FactoryGirl.create(:cothread,
                                   user: FactoryGirl.create(:alice),
                                   title: "a title in English")
    end
  end

  context 'English locale' do
    around(:each) do |example|
      I18n.with_locale(:en) { example.run }
    end

    it "displays nav text" do
      visit cothread_path(@thread)
      within :css, 'h2' do
        page.should have_xpath('//span[./@class="translated"][./@data-attribute="title"]', :text => "a title in English")
        page.should have_xpath('//button[contains(@class,"edit-button")]', :text => "edit")
      end
      within :css, 'ul.nav.nav-pills' do
        page.should have_content "neta"
        page.should have_content "en comments"
        page.should have_content "ja comments"
        page.should have_content "created"
      end
    end

  end

  context 'Japanese locale' do
    around(:each) do |example|
      I18n.with_locale(:ja) { example.run }
    end

    it "displays nav text" do
      visit cothread_path(@thread)
      within :css, 'h2' do
        page.should have_xpath('//span[./@class="untranslated"][./@data-attribute="title"]', :text => "a title in English")
        page.should have_xpath('//button[contains(@class,"edit-button")]', :text => "日本語を追加する")
      end
      within :css, 'ul.nav.nav-pills' do
        page.should have_content "ネタ"
        page.should have_content "enのコメント"
        page.should have_content "jaのコメント"
        page.should have_content "に登録した"
      end
    end

  end

end
