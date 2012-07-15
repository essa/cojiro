class Cothread < ActiveRecord::Base
  attr_accessible :title, :summary, :source_locale

  #scopes
  scope :recent, lambda { order("created_at DESC") }

  translates :title, :summary

  #validations
  validates :user, :presence => true
  validates :title, :presence => true, :if => :in_source_locale?
  validates :source_locale, :presence => :true

  #callbacks
  before_validation :default_values

  #associations
  belongs_to :user

  def in_source_locale?
    (source_locale == Globalize.locale.to_s) or (source_locale == nil)
  end

  def as_json(options = {})
    super(options.merge(:only => [:id, :title, :summary, :created_at, :updated_at, :source_locale],
                        :include => [ :user ],
                        :methods => [ :title_in_source_locale, :summary_in_source_locale ]))
  end

  # define locale helper methods for translated attributes
  translated_attribute_names.each do |attr|
    define_method("#{attr}_in_source_locale") do
      read_attribute attr, { :locale => source_locale }
    end
  end

  private

  def default_values
    self.source_locale ||= I18n.locale.to_s
  end

end
