class Comment < ActiveRecord::Base
  belongs_to :cothread
  belongs_to :link
  attr_accessible :text
end
