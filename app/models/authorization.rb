class Authorization < ActiveRecord::Base
  belongs_to :user

  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end

  def self.create_from_hash!(hash, user = nil)
    user ||= User.new_from_hash(hash)
    auth = Authorization.new(:uid => hash['uid'], :provider => hash['provider'])
    user.authorizations << auth
    user.save!
    auth.save!
    auth
  end

end
