class User < ActiveRecord::Base

  # validations
#  validates :name, :presence => :true

  # associations
  has_many :cothreads
  has_many :authorizations

  def self.new_from_hash(hash)
    new(:name => hash['info']['nickname'],
        :location => hash['info']['location'],
        :profile => hash['info']['description'],
        :fullname => hash['info']['name'])
  end

end
