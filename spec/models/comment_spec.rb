# encoding: utf-8
require 'spec_helper'
require 'timecop'
require 'shoulda-matchers'

describe Comment do
  describe 'associations' do
    it { should belong_to(:link) }
    it { should belong_to(:cothread) }
    it { should belong_to(:user) }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:link).allow_destroy(false) }

    context 'link with url does not yet exist' do
      let(:comment) { FactoryGirl.build(:comment, :with_link) }

      it 'saves comment with link' do
        expect {
          comment.save
        }.to change(Comment, :count).by(1)
      end

      it 'saves link association' do
        expect {
          comment.save
        }.to change(Link, :count).by(1)
      end

      it 'saves link attributes in this locale' do
        comment.link.title = 'a link title'
        comment.save
        comment.reload
        comment.link.title.should == 'a link title'
      end

      it 'saves link attributes in another locale' do
        comment.link.translation_for(:ja).title = 'タイトル'
        comment.save
        comment.reload
        comment.link.translation_for(:ja).title.should == 'タイトル'
      end

      it 'sets user_id from comment' do
        comment.save
        comment.reload
        comment.link.user_id.should == comment.user_id
      end
    end

    # Note: it's important to test updating link translated attributes here
    context 'link with url already exists' do
      let!(:link) { FactoryGirl.create(:link, :with_valid_data) }
      let(:comment) do
        comment = FactoryGirl.build(:comment)
        comment.link = FactoryGirl.build(:link_without_user, url: link.url, source_locale: 'en', title: 'foo')
        comment
      end

      it 'saves comment with link' do
        expect { comment.save }.to change(Comment, :count).by(1)
      end

      it 'does not create new link' do
        expect { comment.save }.not_to change(Link, :count)
      end

      it 'updates link attributes' do
        comment.save
        existing_link = Link.find_by_url(link.url)
        existing_link.url.should == link.url
        existing_link.title.should == 'foo'
      end

      it 'sets user_id from comment' do
        comment.save
        comment.reload
        comment.link.user_id.should == comment.user_id
      end

      it 'sets link_id' do
        comment.save
        comment.reload
        comment.link_id == link.id
      end
    end
  end

  describe 'mass assignment' do
    it { should allow_mass_assignment_of(:text) }
    it { should allow_mass_assignment_of(:link_id) }
    it { should allow_mass_assignment_of(:link_attributes) }

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
      it { should validate_presence_of(:user_id) }
      it { should validate_uniqueness_of(:cothread_id).scoped_to(:link_id) }
    end
  end

  describe '#to_json' do
    before do
      Timecop.freeze(Time.utc(2012,6,11,12,20)) do
        @comment = FactoryGirl.build(:comment, :with_link)
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
