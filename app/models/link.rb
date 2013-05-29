class Link < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :cothreads, :through => :comments
  attr_accessible :embed_data, :summary, :title, :url

  #validations
  validates :status, :presence => true, :numericality => true

  #callbacks
  before_validation :default_values

  private

  def default_values
    self.status ||= 0
  end
end
