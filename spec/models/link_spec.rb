# encoding: utf-8
require 'spec_helper'
require 'shoulda-matchers'
require 'vcr'

describe Link do
  describe 'associations' do
    it { should have_many(:comments) }
    it { should have_many(:cothreads).through(:comments) }
  end

  # url and source_locale are set only when a link is first created
  # and in principle should not be changed thereafter
  describe 'readonly accessors' do
    it { should have_readonly_attribute(:url) }
    it { should have_readonly_attribute(:source_locale) }
  end

  describe 'mass assignment' do
    it { should allow_mass_assignment_of(:url) }
    it { should allow_mass_assignment_of(:source_locale) }
    it { should allow_mass_assignment_of(:title) }
    it { should allow_mass_assignment_of(:summary) }

    it { should_not allow_mass_assignment_of(:user_id) }
    it { should_not allow_mass_assignment_of(:status) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  describe 'validation with factory' do
    let(:link) { FactoryGirl.build(:link) }
    subject { link }

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

    it 'is invalid without a title in source locale if status > 0' do
      subject.status = 1
      subject.title = nil
      should_not be_valid
    end

    it 'is invalid with a title if status = 0' do
      subject.status = 0
      subject.title = 'a title'
      should_not be_valid
    end

    it 'is invalid with a summary if status = 0' do
      subject.status = 0
      subject.summary = 'a summary'
      should_not be_valid
    end

    it 'is valid without a title in other locales' do
      # need to do this to ensure that Globalize.locale is reset
      # even if test fails
      subject.status = 1
      begin
        subject.title = 'a title'
        Globalize.locale = :fr
        subject.title = nil
        should be_valid
      ensure
        Globalize.locale = nil
      end
    end

    it 'is invalid without user' do
      subject.user = nil
      should_not be_valid
    end

    it 'is invalid with a blank url' do
      subject.url = ""
      should_not be_valid
    end

    # callback was crashing on nil url
    # added this to check
    it 'is invlid with a nil url' do
      subject.url = nil
      should_not be_valid
    end

    it 'is invalid without a unique url (after normalization)' do
      FactoryGirl.create(:link, :url => 'http://www.example.com')
      subject.url = 'www.example.com'
      should_not be_valid
    end
  end

  describe '#to_json' do
    use_vcr_cassette('what_is_crossfit')
    let(:link) do
      link = FactoryGirl.create(:link,
                                :url => 'http://youtu.be/tzD9BkXGJ1M',
                                :source_locale => 'en',
                                :user => FactoryGirl.create(:user, :name => 'foo'))
      link.status = 1
      link.update_attributes!(:title => 'What is CrossFit?',
                              :summary => 'CrossFit is an effective way to get fit. Anyone can do it.')
      link
    end

    subject { JSON(link.to_json) }
    its(['id']) { should be }
    its(['title']) { should == { 'en' => 'What is CrossFit?' } }
    its(['summary']) { should == { 'en' => 'CrossFit is an effective way to get fit. Anyone can do it.' } }
    its(['site_name']) { should == 'www.youtube.com' }
    its(['user']) { should == 'foo' }
    its(['url']) { should == 'http://youtu.be/tzD9BkXGJ1M' }
    its(['source_locale']) { should == 'en' }
    it 'does not include any other attributes' do
      subject.keys.delete_if { |k|
        %w[ id title summary url source_locale site_name user ].include?(k)
      }.should be_empty
    end
  end

  describe 'default values' do
    let(:link) { FactoryGirl.create(:link) }

    it 'sets default status' do
      link.status = nil
      link.save
      link.status.should == 0
    end

    it 'sets default source language' do
      link.source_locale = nil
      link.save
      link.source_locale.should == "en"
    end
  end

  # defined in spec/support/shared_examples.rb
  describe 'globalize helpers' do
    let!(:model) { FactoryGirl.create(:link) }

    describe 'title' do
      it_behaves_like 'attribute with locale methods', 'title'
      it_behaves_like 'attribute with nested translation accessors', 'title'
    end

    describe 'summary' do
      it_behaves_like 'attribute with locale methods', 'summary'
      it_behaves_like 'attribute with nested translation accessors', 'summary'
    end
  end

  describe 'normalization' do
    it 'adds http:// if missing' do
      link = FactoryGirl.create(:link, :url => 'www.foo.com')
      link.url.should match("^http://www.foo.com/")
    end

    it 'adds trailing forward-slash if missing' do
      link = FactoryGirl.create(:link, :url => 'www.foo.com')
      link.url.should match("www.foo.com/$")
    end

    it 'normalizes non-ascii urls' do
      link = FactoryGirl.create(:link, :url => 'http://お名前.com')
      link.url.should == 'http://xn--t8jx73hngb.com/'
    end
  end

  describe 'scopes' do
    describe '.by_url' do
      let!(:link) { FactoryGirl.create(:link, :url => 'http://www.foo.com/') }

      it 'finds link by normalized url' do
        Link.by_url('http://www.foo.com').first.should == link
      end

      it 'heuristically parses query url' do
        Link.by_url('www.foo.com').first.should == link
      end
    end
  end

  describe 'get embed data' do
    use_vcr_cassette('what_is_crossfit')
    let(:link) { FactoryGirl.create(:link, :url => 'http://youtu.be/tzD9BkXGJ1M') }
    subject { link.embed_data }
    its(["description"]) { should == 'What is CrossFit? CrossFit is an effective way to get fit. Anyone can do it. It is a fitness program that combines a wide variety of functional movements into a timed or scored workout. We do pull-ups, squats, push-ups, weightlifting, gymnastics, running, rowing, and a host of other movements.' }
    its(["provider_url"]) { should == 'http://www.youtube.com/' }
    its(["author_name"]) { should == 'CrossFit' }
    its(["height"]) { should == 480 }
    its(["width"]) { should == 854 }
    its(["thumbnail_height"]) { should == 360 }
    its(["thumbnail_width"]) { should == 480 }
    its(["author_url"]) { should == 'http://www.youtube.com/user/CrossFitHQ' }
    its(["type"]) { should == 'video' }
    its(["provider_name"]) { should == 'YouTube' }
    its(["thumbnail_url"]) { should == 'http://i1.ytimg.com/vi/tzD9BkXGJ1M/hqdefault.jpg' }
    its(["html"]) { should == '<iframe width="854" height="480" src="http://www.youtube.com/embed/tzD9BkXGJ1M?feature=oembed" frameborder="0" allowfullscreen></iframe>' }
  end

  describe 'embed helper methods' do
    context 'for a link with valid embed data' do
      around(:each) do |example|
        VCR.use_cassette('what_is_crossfit') do
          example.run
        end
      end
      subject { FactoryGirl.create(:link, :url => 'http://youtu.be/tzD9BkXGJ1M') }
      its(:site_name) { should == 'www.youtube.com' }
    end

    context 'for a link with missing embed data' do
      it 'returns nil site name if provider_url is nil' do
        link = FactoryGirl.build(:link)
        link.stub(:embed_data).and_return {}
        link.site_name.should == nil
      end
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
