Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end

if (ENV["RAILS_ENV"] == 'test' || ENV["RAILS_ENV"] == 'development')
  module OmniAuthHelpers
    def self.add_twitter_mock(uid, name, nickname)
      OmniAuth.config.add_mock(:twitter,
                               { :provider => 'twitter',
                                 :uid => uid,
                                 :info => { :name => name, :nickname => nickname }})
    end
    def add_twitter_mock(uid, name, nickname)
      OmniAuthHelpers.add_twitter_mock(uid, name, nickname)
    end
  end
end
