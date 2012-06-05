require 'open-uri'

class User < ActiveRecord::Base
  attr_accessible :name, :fullname, :location, :profile, :mysite, :remote_avatar_url

  # validations
  validates :name, :presence => true, :uniqueness => true
  validates :fullname, :presence => true
  validates :avatar, :presence => true

  # associations
  has_many :cothreads
  has_many :authorizations

  mount_uploader :avatar, AvatarUploader

  def self.new_from_hash(hash)
    new(:name => hash['info']['nickname'],
        :location => hash['info']['location'],
        :profile => hash['info']['description'],
        :fullname => hash['info']['name'],
        :remote_avatar_url => hash['info']['image'].gsub('_normal', ''))
  end

  def self.current_user=(user)
    Thread.current[:cojiro_current_user] = user
  end

  def self.current_user
    Thread.current[:cojiro_current_user]
  end

  # it's not ideal to be overriding serializable_hash instead of as_json,
  # but it seems this is the easiest way to ensure that custom options are
  # inherited in associations
  #
  # ref: https://github.com/rails/rails/pull/2200
  def serializable_hash(options = {})
    super(options.merge(:only => [:id, :name, :fullname, :location, :profile], :methods => [ :avatar_url, :avatar_mini_url ]))
  end

  # ref: https://groups.google.com/forum/?fromgroups#!topic/carrierwave/7geR0hdJp34
  def avatar_mini_url
    avatar.mini.url unless avatar.nil?
  end

end
