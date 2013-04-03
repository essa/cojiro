class Link < ActiveRecord::Base
  belongs_to :user
  belongs_to :cothread
  attr_accessible :embed_data, :summary, :title, :url
end
