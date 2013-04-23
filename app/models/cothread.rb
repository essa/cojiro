class Cothread < ActiveRecord::Base
  attr_accessible :title, :summary, :source_locale

  #scopes
  scope :recent, order("cothreads.created_at DESC")

  translates :title, :summary

  #validations
  validates :user, :presence => true
  validates :title, :presence => true, :if => :in_source_locale?
  validates :source_locale, :presence => :true

  #callbacks
  before_validation :default_values

  #associations
  belongs_to :user

  class << self
    def new_from_json(attributes)
      translated_keys = attributes.keys & translated_attribute_names.map(&:to_s)
      new_cothread = new(attributes.except(*translated_keys))
      translated_keys.each do |key|
        new_cothread.send("#{key}_translations=", attributes[key])
      end
      new_cothread
    end
  end

  def set_from_json(attributes)
    if attributes && attributes.keys
      translated_keys = attributes.keys & translated_attribute_names.map(&:to_s)
      untranslated_keys = attributes.keys - translated_keys
      translated_keys.each do |key|
        attributes[key] && send("#{key}_translations=", attributes[key])
      end
      untranslated_keys.each { |key| send("#{key}=", attributes[key]) }
    end
    self
  end

  def in_source_locale?
    (source_locale == Globalize.locale.to_s) or (source_locale == nil)
  end

  def as_json(options = {})
    json = super(options.merge(:only => [:id, :created_at, :updated_at, :source_locale],
                               :include => [ :user ]))
    translated_attribute_names.each do |attr|
      json.merge!(attr => send("#{attr}_translations"))
    end
    json
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
