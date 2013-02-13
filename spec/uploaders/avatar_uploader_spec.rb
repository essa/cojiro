require 'spec_helper'
require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  before do
    AvatarUploader.enable_processing = true
    @user = FactoryGirl.create(:user)
    @uploader = AvatarUploader.new(@user, :avatar)
    @uploader.store!(File.open(fixture_path + '/' + '400x500.png'))
  end

  after do
    AvatarUploader.enable_processing = false
    @uploader.remove!
  end

  # see spec_helper.rb for details on cache_dir and store_dir aliases
  it "saves the avatar in the correct directory based on the user id" do
    @uploader.store_dir_without_test_env.should == "uploads/avatars/#{@user.id}"
  end

  it "saves the avatar using the original filename" do
    @uploader.filename.should == "400x500.png"
  end

  context 'mini version' do

    it 'resizes the avatar to fit into 32 by 32 pixels' do
      @uploader.mini.should be_no_larger_than(32, 32)
    end

  end

end
