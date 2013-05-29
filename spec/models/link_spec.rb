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
  end
end
