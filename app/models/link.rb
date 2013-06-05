class Link < ActiveRecord::Base
  translates :title, :summary
  include GlobalizeHelpers

  belongs_to :user
  has_many :comments
  has_many :cothreads, :through => :comments
  attr_accessible :embed_data, :summary, :title, :url, :source_locale

  #validations
  validates :status, :presence => true, :numericality => true

  #callbacks
  before_validation :default_values

  private

  def default_values
    self.status ||= 0
    self.source_locale ||= I18n.locale.to_s
  end
end
