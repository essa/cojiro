class Cothread < ActiveRecord::Base
  attr_accessible :title, :summary, :source_language

  translates :title, :summary

  #validations
  validates :user, :presence => :true
  validates :title, :presence => :true #, :if => :in_original_language?
  validates :source_language, :presence => :true

  #callbacks
  before_validation :default_values

  #associations
  belongs_to :user

  def as_json(options = {})
    super(options.merge(:include => [ :user ]))
#                        :only => [:title, :summary, :created_at, :updated_at, :source_language]))
  end

#  def in_original_language?
#    (self.original_language == Globalize.locale.to_s) || (self.original_language == nil)
#  end

  private

  def default_values
    self.source_language ||= I18n.locale
  end

end
