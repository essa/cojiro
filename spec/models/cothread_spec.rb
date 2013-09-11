require 'spec_helper'
require 'timecop'
require 'shoulda-matchers'

describe Cothread do
  before do
    I18n.locale = 'en'
  end

  let(:alice) { FactoryGirl.create(:alice) }
  let(:bob) { FactoryGirl.create(:bob) }

  describe 'associations' do
    it { should have_many(:comments) }
    it { should have_many(:links).through(:comments) }
  end

  describe "validation with factory" do
    before do
      @cothread = FactoryGirl.build(:cothread)
    end

    subject { @cothread }

    it "has a valid factory" do
      should be_valid
    end

    it "is invalid without a title in source locale" do
      # need to switch to other locale to make sure we are validating
      # presence of the title in the source locale explicitly
      I18n.with_locale(:fr) do
        subject.source_locale = 'en'
        subject.title_translations = { :en => "" }
        should_not be_valid
      end
    end

    it 'is valid with a title in source locale' do
      Globalize.with_locale(:ja) do
        FactoryGirl.create(:cothread, :source_locale => 'ja', :title => 'title').should be_valid
      end
    end

    it "is valid without a title in other locale" do
      Globalize.with_locale(:ja) do
        subject.title = ""
        should be_valid
      end
    end

    it "is invalid without a user" do
      subject.user = nil
      should_not be_valid
    end

  end

  describe "default values" do
    before do
      @cothread = FactoryGirl.create(:cothread)
    end

    it "sets default source language" do
      @cothread.source_locale = nil
      @cothread.save
      @cothread.source_locale.should == "en"
    end
  end

  # defined in spec/support/shared_examples.rb
  describe 'globalize helpers' do
    let!(:model) { FactoryGirl.create(:cothread) }

    describe 'title' do
      it_behaves_like 'attribute with locale methods', 'title'
      it_behaves_like 'attribute with nested translation accessors', 'title'
    end

    describe 'summary' do
      it_behaves_like 'attribute with locale methods', 'summary'
      it_behaves_like 'attribute with nested translation accessors', 'summary'
    end
  end

  describe "#to_json" do
    before do
      Timecop.freeze(Time.utc(2002,7,20,12,20)) do
        @cothread = FactoryGirl.build(:cothread,
                                      user: FactoryGirl.create(:csasaki))
        Globalize.with_locale(:fr) do
          @cothread.title = "title in French"
          @cothread.summary = "summary in French"
        end
        @cothread.save
        FactoryGirl.create(:comment, cothread: @cothread, user: alice)
        FactoryGirl.create(:comment, cothread: @cothread, user: bob)
        FactoryGirl.create(:comment, cothread: @cothread, user: bob)
        @cothread.reload
      end
    end
    let(:cothread_json) { JSON(@cothread.to_json) }
    subject { cothread_json }
    its(['id']) { should be }
    its(['title']) { should == { "en" => @cothread.title, "fr" => "title in French" } }
    its(['summary']) { should == { "en" => @cothread.summary, "fr" => "summary in French" } }
    its(['created_at']) { should == "2002-07-20T12:20:00Z" }
    its(['updated_at']) { should == "2002-07-20T12:20:00Z" }
    its(['source_locale']) { should be }

    its(['user']) { should be }
    its(['user']) { should have_key('name') }
    its(['user']) { should have_key('fullname') }
    its(['user']) { should have_key('location') }
    its(['user']) { should have_key('profile') }
    its(['user']) { should have_key('avatar_url') }
    its(['user']) { should have_key('avatar_mini_url') }

    its(['participants']) { should be }

    describe 'participants' do
      subject { cothread_json['participants'].map { |hash| hash['name'] } }
      its(:size) { should == 2 }
      it { should include 'alice' }
      it { should include 'bob' }

      describe 'participant json' do
        subject { cothread_json['participants'].select { |a| a['name'] == 'alice' }.first }
        it { should have_key('fullname') }
        it { should have_key('location') }
        it { should have_key('profile') }
        it { should have_key('avatar_url') }
        it { should have_key('avatar_mini_url') }
      end
    end

    describe 'comments' do
      subject { cothread_json['comments'] }
      its([0]) { should be }
      its([0]) { should have_key('text') }
      its([0]) { should_not have_key('cothread_id') }
      its([0]) { should_not have_key('link_id') }
      its([1]) { should be }
      its([1]) { should have_key('text') }
      its([1]) { should_not have_key('cothread_id') }
      its([1]) { should_not have_key('link_id') }
      its([2]) { should be }
      its([2]) { should have_key('text') }
      its([2]) { should_not have_key('cothread_id') }
      its([2]) { should_not have_key('link_id') }
    end

    describe 'link associated through comment' do
      before do
        link = @cothread.comments[0].link = FactoryGirl.create(:link)
        link.stub(:site_name).and_return('www.foo.com')
      end
      subject { JSON(@cothread.to_json)['comments'][0]['link'] }
      it { should be }
      its(['site_name']) { should == 'www.foo.com' }
    end

    it "does not include any other attributes" do
      cothread_json.keys.delete_if { |k|
        [ "id",
          "title",
          "title_in_source_locale",
          "summary",
          "summary_in_source_locale",
          "created_at",
          "updated_at",
          "source_locale",
          "user",
          "comments",
          'participants'
        ].include?(k)
      }.should be_empty
    end
  end

  describe '#participants' do
    before do
      # alice and bob are our two users
      @alices_cothread = FactoryGirl.create(:cothread, user: alice)
      @bobs_cothread = FactoryGirl.create(:cothread, user: bob)

      # two more users
      @csasaki = FactoryGirl.create(:csasaki)
      @user = FactoryGirl.create(:user)

      # bob has added @bobs_link to @bobs_thread
      @bobs_link = FactoryGirl.create(:link, user: bob)
      @bobs_comment = FactoryGirl.create(:comment, link: @bobs_link, user: bob, cothread: @bobs_cothread)

      # now csasaki adds the same link to alice's thread
      @csasakis_comment = FactoryGirl.create(:comment, link: @bobs_link, user: @csasaki, cothread: @alices_cothread)

      @alices_cothread.reload
    end
    let(:participants) { @alices_cothread.participants }

    it 'returns all users who have added comments or links to the thread' do
      participants.should include(bob)
      participants.should include(@csasaki)
    end

    it 'does not include the creator of the thread itself' do
      participants.size.should == 2
      participants.should_not include(alice)
    end

    it 'does not include other users' do
      participants.should_not include(@user)
    end
  end
end
