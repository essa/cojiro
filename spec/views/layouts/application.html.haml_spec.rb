# encoding: utf-8
require 'spec_helper'

describe 'layouts/application' do

  before do
    @start_a_thread =
      { :en => "Start a thread",
        :ja => "スレッドを立てる" }
    @twitter_sign_in =
      { :en => "Sign in through Twitter",
        :ja => "Twitterでサインインする" }
    @logout =
      { :en => "Logout",
        :ja => "ログアウト" }
  end

  context "logged-out user" do
    before { view.stub(:logged_in?) { false } }

    shared_examples_for "logged-out user homepage" do |locale|
      around(:each) do |example|
        I18n.with_locale(locale) { example.run }
      end

      it "does not render start a thread link" do
        render
        rendered.should_not have_link(@start_a_thread[locale])
      end

      it "does not render a logout link" do
        render
        rendered.should_not have_link(@logout[locale])
      end

      it "renders twitter sign-in link" do
        render
        rendered.should have_link(@twitter_sign_in[locale])
      end

    end

    context "English locale" do
      it_behaves_like "logged-out user homepage", :en
    end

    context "Japanese locale" do
      it_behaves_like "logged-out user homepage", :ja
    end

    context "logged-in user" do
      before do
        view.stub(:logged_in?) { true } 
        assign(:current_user, FactoryGirl.create(:user))
      end

      shared_examples_for "logged-in user homepage" do |locale|
        around(:each) do |example|
          I18n.with_locale(locale) { example.run }
        end

        it "renders start a thread link" do
          render
          rendered.should have_link(@start_a_thread[locale])
        end

        it "renders start a logout link" do
          render
          rendered.should have_link(@logout[locale])
        end

        it "does not render twitter sign-in link" do
          render
          rendered.should_not have_link(@twitter_sign_in[locale])
        end

      end

      context "English locale" do
        it_behaves_like "logged-in user homepage", :en
     end

      context "Japanese locale" do
        it_behaves_like "logged-in user homepage", :ja
      end

    end
  end
end
