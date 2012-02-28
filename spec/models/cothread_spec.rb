require 'spec_helper'

describe Cothread do
  before do
    I18n.locale = 'en'
  end

  describe "validation with factory" do
    before do
      @cothread = Factory(:cothread)
    end

    subject { @cothread }

    it "should be valid created by factory" do
      should be_valid
    end

    it "should be invalid without a title" do
      subject.title = ""
      should_not be_valid
    end

    it "should be invalid without a user" do
      subject.user = nil
      should_not be_valid
    end
  end

end
