require 'addressable/uri'

class Link < ActiveRecord::Base
  translates :title, :summary
  include GlobalizeHelpers

  belongs_to :user
  has_many :comments
  has_many :cothreads, :through => :comments
  attr_accessible :embed_data, :summary, :title, :url, :source_locale

  #validations
  validates :user, :presence => true
  validates :url, :presence => true, :uniqueness => true
  validates :status, :presence => true, :numericality => true
  validate :title_present_in_source_locale

  #callbacks
  before_validation :default_values
  before_validation :parse_and_normalize_url

  private

  def default_values
    self.status ||= 0
    self.source_locale ||= I18n.locale.to_s
  end

  def parse_and_normalize_url
    uri = Addressable::URI.heuristic_parse(url)
    self.url = uri.normalize.to_s
  end

  def title_present_in_source_locale
    return unless status > 0
    Globalize.with_locale(source_locale) do
      errors.add(:title, I18n.t('errors.messages.blank')) unless title.present?
    end
  end
end
