class Link < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :cothreads, :through => :comments
  attr_accessible :embed_data, :summary, :title, :url
end
