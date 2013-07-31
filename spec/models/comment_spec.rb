require 'spec_helper'
require 'timecop'
require 'shoulda-matchers'

describe Comment do
  describe 'associations' do
    it { should belong_to(:link) }
    it { should belong_to(:cothread) }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:link).allow_destroy(false) }
  end

  describe 'mass assignment' do
    it { should allow_mass_assignment_of(:text) }
    it { should allow_mass_assignment_of(:link_id) }

    it { should_not allow_mass_assignment_of(:cothread_id) }
    it { should_not allow_mass_assignment_of(:user_id) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  describe 'validation with factory' do
    let(:comment) { FactoryGirl.build(:comment) }
    subject { comment }

    it 'has a valid factory' do
      should be_valid
    end

    describe 'cothread' do
      it { should validate_presence_of(:cothread_id) }
      it { should validate_uniqueness_of(:cothread_id).scoped_to(:link_id) }
    end
  end

  describe '#to_json' do
    before do
      Timecop.freeze(Time.utc(2012,6,11,12,20)) do
        @comment = FactoryGirl.build(:comment,
                                     link: FactoryGirl.create(:link))
        @comment.save
      end
      @comment_json = @comment.to_json
    end
    subject { JSON(@comment.to_json) }
    its(['id']) { should be }
    its(['text']) { should be }
    its(['created_at']) { should == "2012-06-11T12:20:00Z" }
    its(['updated_at']) { should == "2012-06-11T12:20:00Z" }
    its(['link']) { should be }
    its(['link']) { should have_key('url') }

    it 'does not include any other attributes' do
      subject.keys.delete_if { |k|
        [ 'id', 'text', 'created_at', 'updated_at', 'link' ].include?(k)
      }.should be_empty
    end
  end
end
