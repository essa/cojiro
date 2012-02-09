class User < ActiveRecord::Base

  # validations
#  validates :name, :presence => :true

  # associations
  has_many :cothreads

end
