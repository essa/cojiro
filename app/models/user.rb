class User < ActiveRecord::Base

  # associations
  has_many :cothreads
  has_many :authorizations

  def self.new_from_hash(hash)
    new(:name => hash['info']['nickname'],
        :location => hash['info']['location'],
        :profile => hash['info']['description'],
        :fullname => hash['info']['name'])
  end

  def self.current_user=(user)
    Thread.current[:cojiro_current_user] = user
  end

  def self.current_user
    Thread.current[:cojiro_current_user]
  end

end
