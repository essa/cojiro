class Cothread < ActiveRecord::Base
  attr_accessible :title, :summary, :source_language

  #scopes
  scope :recent, lambda { order("created_at DESC") }

  translates :title, :summary

  #validations
  validates :user, :presence => true
  validates :title, :presence => true
  validates :source_language, :presence => :true

  #callbacks
  before_validation :default_values

  #associations
  belongs_to :user

  def as_json(options = {})
    super(options.merge(:only => [:id, :title, :summary, :created_at, :updated_at, :source_language],
                        :include => [ :user ]))
  end

#  def in_original_language?
#    (self.original_language == Globalize.locale.to_s) || (self.original_language == nil)
#  end

  private

  def default_values
    self.source_language ||= I18n.locale
  end

end
