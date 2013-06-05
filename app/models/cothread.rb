require 'globalize_helpers'

class Cothread < ActiveRecord::Base
  translates :title, :summary
  include GlobalizeHelpers

  attr_accessible :title, :summary, :source_locale

  #scopes
  scope :recent, order("cothreads.created_at DESC")

  #validations
  validates :user, :presence => true
  validates :title, :presence => true, :if => :in_source_locale?
  validates :source_locale, :presence => :true

  #callbacks
  before_validation :default_values

  #associations
  belongs_to :user
  has_many :comments
  has_many :links, :through => :comments

  def write_attribute(name, value, options = {})
    if translated?(name) && value.is_a?(Hash)
      send("#{name}_translations=", value)
    else
      super(name, value, options)
    end
  end

  def in_source_locale?
    (source_locale == Globalize.locale.to_s) or (source_locale == nil)
  end

  def as_json(options = {})
    json = super(options.merge(:only => [:id, :created_at, :updated_at, :source_locale],
                               :include => [ :user ]))
    translated_attribute_names.each do |attr|
      translations = send("#{attr}_translations").delete_if { |_,v| v.nil? }
      json.merge!(attr => translations)
    end
    json
  end

  private

  def default_values
    self.source_locale ||= I18n.locale.to_s
  end

end
