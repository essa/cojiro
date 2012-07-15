class Cothread < ActiveRecord::Base
  attr_accessible :title, :summary, :source_language

  #scopes
  scope :recent, lambda { order("created_at DESC") }

  translates :title, :summary

  #validations
  validates :user, :presence => true
  validates :title, :presence => true, :if => :in_source_language?
  validates :source_language, :presence => :true

  #callbacks
  before_validation :default_values

  #associations
  belongs_to :user

  def in_source_language?
    (source_language == Globalize.locale.to_s) or (source_language == nil)
  end

  def as_json(options = {})
    super(options.merge(:only => [:id, :title, :summary, :created_at, :updated_at, :source_language],
                        :include => [ :user ],
                        :methods => [ :title_in_source_language, :summary_in_source_language ]))
  end

  # define locale helper methods for translated attributes
  translated_attribute_names.each do |attr|
    define_method("#{attr}_in_source_language") do
      read_attribute attr, { :locale => source_language }
    end
  end

  private

  def default_values
    self.source_language ||= I18n.locale.to_s
  end

end
