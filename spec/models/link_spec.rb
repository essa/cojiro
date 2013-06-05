require 'spec_helper'
require 'shoulda-matchers'

describe Link do
  describe 'associations' do
    it { should have_many(:comments) }
    it { should have_many(:cothreads).through(:comments) }
  end

  describe 'validation with factory' do
    before do
      @link = FactoryGirl.build(:link)
    end

    subject { @link }

    it 'has a valid factory' do
      should be_valid
    end

    # default value callback set status to true, so this will fail
    pending 'is invalid without a status' do
      subject.status = nil
      should_not be_valid
    end

    it 'is invalid with a non-integer status' do
      subject.status = "status"
      should_not be_valid
    end

    it 'validates presence of title in source locale if status > 0' do
      subject.status = 1
      subject.title = nil
      should_not be_valid
    end

    it 'does not validate presence of title if status = 0' do
      subject.status = 0
      subject.title = nil
      should be_valid
    end

    it 'does not validate presence of title in other locales' do
      # need to do this to ensure that Globalize.locale is reset
      # even if test fails
      subject.status = 1
      begin
        Globalize.locale = :fr
        subject.title = nil
        should be_valid
      ensure
        Globalize.locale = nil
      end
    end
  end

  describe 'default values' do
    before do
      @link = FactoryGirl.create(:link)
    end

    it 'sets default status' do
      @link.status = nil
      @link.save
      @link.status.should == 0
    end

    it 'sets default source language' do
      @link.source_locale = nil
      @link.save
      @link.source_locale.should == "en"
    end
  end

  describe "locale helper methods" do
    let!(:model) { FactoryGirl.create(:link) }

    describe "title" do
      it_behaves_like 'attribute with locale methods', 'title'
    end

    describe "summary" do
      it_behaves_like 'attribute with locale methods', 'summary'
    end
  end
end
