# encoding: utf-8
require 'spec_helper'
require 'shoulda-matchers'
require 'timecop'
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
    it { should have_readonly_attribute(:embed_data) }
  end

  describe 'mass assignment' do
    it { should allow_mass_assignment_of(:url) }
    it { should allow_mass_assignment_of(:source_locale) }
    it { should allow_mass_assignment_of(:title) }
    it { should allow_mass_assignment_of(:summary) }

    it { should_not allow_mass_assignment_of(:user_id) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  describe 'validation with factory' do
    let(:link) { FactoryGirl.build(:link) }
    subject { link }

    it 'has a valid factory' do
      should be_valid
    end

    it 'has a factory for creating invalid links' do
      FactoryGirl.build(:link, :invalid).should_not be_valid
    end

    describe 'title' do
      describe 'with source locale set' do
        it 'is invalid without a title in source locale' do
          subject.source_locale = :en
          subject.title = nil
          should_not be_valid
        end

        it 'has correct validation error when title not set in source locale' do
          subject.source_locale = :ja
          subject.title = nil
          Globalize.with_locale(:ja) { subject.valid? }
          subject.errors.messages[:title].should include 'can\'t be blank in Japanese'
        end

        it 'is valid without a title in other locales if source_locale is set' do
          subject.source_locale = 'en'
          subject.title = 'a title'
          Globalize.with_locale(:fr) { should be_valid }
        end
      end
    end

    describe 'user' do
      it { should validate_presence_of(:user) }
    end

    describe 'url' do
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
  end

  describe '#to_json' do
    describe 'CrossFit YouTube video in English' do
      use_vcr_cassette('what_is_crossfit')
      let(:link) do
        link = Timecop.freeze(Time.utc(2008,8,20,12,20)) do
          FactoryGirl.create(:link,
                             :url => 'http://youtu.be/tzD9BkXGJ1M',
                             :source_locale => 'en',
                             :user => FactoryGirl.create(:user, :name => 'foo'),
                             :title => 'What is CrossFit?',
                             :summary => 'CrossFit is an effective way to get fit. Anyone can do it.')
        end
        Timecop.freeze(Time.utc(2009,1,20,10,00)) do
          link.touch
        end
        link
      end

      subject { JSON(link.to_json) }
      its(['id']) { should be }
      its(['created_at']) { should == '2008-08-20T12:20:00Z' }
      its(['updated_at']) { should == '2009-01-20T10:00:00Z' }
      its(['title']) { should == { 'en' => 'What is CrossFit?' } }
      its(['summary']) { should == { 'en' => 'CrossFit is an effective way to get fit. Anyone can do it.' } }
      its(['site_name']) { should == 'www.youtube.com' }
      its(['user_name']) { should == 'foo' }
      its(['url']) { should == 'http://youtu.be/tzD9BkXGJ1M' }
      its(['source_locale']) { should == 'en' }
      it 'does not include any other attributes' do
        subject.keys.delete_if { |k|
          %w[ id created_at updated_at title summary url display_url source_locale embed_data site_name user_name ].include?(k)
        }.should be_empty
      end
      its(['embed_data']) { should be }
      its(['embed_data']) { should include('title' => 'What is CrossFit?') }
    end

    describe 'Wikipedia page in Japanese' do
      use_vcr_cassette('capoeira_wikipedia_ja')
      let(:link) do
        FactoryGirl.create(:link, :url => 'ja.wikipedia.org/wiki/カポエイラ')
      end

      subject { JSON(link.to_json) }
      its(['url']) { should == 'http://ja.wikipedia.org/wiki/%E3%82%AB%E3%83%9D%E3%82%A8%E3%82%A4%E3%83%A9' }
      its(['display_url']) { should == 'http://ja.wikipedia.org/wiki/カポエイラ' }
    end
  end

  describe '#to_param' do
    let(:user) { FactoryGirl.create(:link, :url => 'http://www.foo.com').to_param }
    it 'returns the user name' do
      user.to_param.should == 'http://www.foo.com/'
    end
  end

  describe 'default values' do
    let(:link) { FactoryGirl.create(:link) }

    # spec default values here, currently none
  end

  # defined in spec/support/shared_examples.rb
  describe 'globalize helpers' do
    let!(:model) { FactoryGirl.build(:link, source_locale: I18n.locale) }

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

    it 'encodes special characters' do
      link = FactoryGirl.create(:link, :url => 'http://ja.wikipedia.org/wiki/カポエイラ')
      link.url.should == 'http://ja.wikipedia.org/wiki/%E3%82%AB%E3%83%9D%E3%82%A8%E3%82%A4%E3%83%A9'
    end

    it 'normalizes non-ascii urls' do
      link = FactoryGirl.create(:link, :url => 'http://お名前.com')
      link.url.should == 'http://xn--t8jx73hngb.com/'
    end
  end

  describe '.find_by_url' do
    context 'link with url exists' do
      let!(:link) { FactoryGirl.create(:link, :url => 'http://www.foo.com/') }

      it 'finds link for exact url match' do
        Link.find_by_url('http://www.foo.com/').should == link
      end

      it 'finds link for normalized url match' do
        Link.find_by_url('www.foo.com').should == link
      end
    end

    context 'link with url does not exist' do
      it 'finds link for exact url match' do
        Link.find_by_url('http://www.foo.com/').should be_nil
      end
    end
  end

  describe '.initialize_by_url' do
    let(:user) { FactoryGirl.create(:alice) }

    context 'link with url exists' do
      let(:valid_attrs) { { :url => 'http://www.foo.com/', :title => 'a title', :source_locale => 'en', :user => user } }
      let!(:link) { FactoryGirl.create(:link, valid_attrs) }

      it 'does not change the number of links' do
        expect { Link.initialize_by_url('www.foo.com', :title => 'a new title') }.not_to change(Link, :count)
      end

      it 'is not a new record' do
        Link.initialize_by_url('www.foo.com', :title => 'a new title').should_not be_new_record
      end

      it 'returns existing link if link with url already exists' do
        Link.initialize_by_url('www.foo.com', :title => 'a new title').should == link
      end

      it 'assigns new attributes' do
        link = Link.initialize_by_url('www.foo.com', :title => 'a new title')
        link.title.should == 'a new title'
      end

      it 'leaves existing attributes unchanged' do
        link = Link.initialize_by_url('www.foo.com', :title => 'a new title')
        link.user.should == user
      end

      it 'returns link unchanged if passed no attributes hash' do
        Link.initialize_by_url('www.foo.com').should == link
      end

      it 'does not allow mass assignment of protected attributes' do
        expect {
          Link.initialize_by_url('www.foo.com', :user_id => 10)
        }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end

    context 'link with url does not exist' do
      let(:new_attrs) { { :title => 'a new title', :summary => 'a summary' } }

      it 'does not change the number of links' do
        expect {
          Link.initialize_by_url('www.bar.com', new_attrs)
        }.not_to change(Link, :count)
      end

      it 'is a new record' do
          Link.initialize_by_url('www.bar.com', new_attrs).should be_new_record
      end

      it 'assigns attributes' do
        link = Link.initialize_by_url('www.bar.com', new_attrs)
        link.title.should == 'a new title'
        link.summary.should == 'a summary'
      end

      it 'normalizes url' do
        link = Link.initialize_by_url('www.bar.com', new_attrs)
        link.url.should == 'http://www.bar.com/'
      end

      it 'does not allow mass assignment of protected attributes' do
        expect {
          Link.initialize_by_url('www.foo.com', :user_id => 10)
        }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end

  describe '#status' do
    let!(:link) { FactoryGirl.build(:link) }

    it 'has a status of 0 if source_locale is not defined' do
      link.status.should == 0
    end

    it 'has a status of 1 if source_locale is defined' do
      link.source_locale = 'en'
      link.status.should == 1
    end
  end

  describe '#display_url' do
    it 'unescapes url characters' do
      link = FactoryGirl.create(:link, url: 'http://ja.wikipedia.org/wiki/%E3%82%AB%E3%83%9D%E3%82%A8%E3%82%A4%E3%83%A9')
      link.display_url.should == 'http://ja.wikipedia.org/wiki/カポエイラ'
    end

    it 'returns display-friendly basename' do
      link = FactoryGirl.create(:link, url: 'http://xn--1sqt31d.com/')
      link.display_url.should == 'http://価格.com/'
    end

    it 'handles invalid urls gracefully' do
      expect {
        FactoryGirl.build(:link, url: 'jjj').display_url
      }.not_to raise_error
    end

    it 'defaults to returning url as string if url has no host' do
      link = FactoryGirl.build(:link, url: 'jjj')
      link.url.should == 'jjj'
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
end
