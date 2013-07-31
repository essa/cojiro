require 'addressable/uri'
require 'embedly'
require 'globalize_helpers'

class Link < ActiveRecord::Base
  translates :title, :summary
  include GlobalizeHelpers

  serialize :embed_data, JSON

  belongs_to :user
  has_many :comments
  has_many :cothreads, :through => :comments

  #readonly accessors
  attr_readonly :url, :embed_data

  #accessible
  attr_accessible :url, :source_locale, :title, :summary

  #validations
  validates :user, :presence => true
  validates :url, :presence => true, :uniqueness => true
  validate :title_present_in_source_locale

  #callbacks
  before_validation :default_values
  before_validation :parse_and_normalize_url
  before_create :get_embed_data

  def self.initialize_by_url(url, attrs = {})
    normalized_url = parse_and_normalize(url)
    if link = where(:url => normalized_url).first
      link.assign_attributes(attrs)
    else
      link = new({ url: normalized_url }.merge(attrs))
    end
    link
  end

  def site_name
    if (embed_data && provider_url = embed_data['provider_url'])
      provider_url.gsub(/^http:\/\//,'').chomp('/')
    end
  end

  def display_uri
    uri = Addressable::URI.heuristic_parse(url)
    uri.host ? uri.display_uri : uri.to_s
  end

  def display_url
    Addressable::URI.unencode(display_uri)
  end

  def user_name
    user && user.name
  end

  def status
    source_locale ? 1 : 0
  end

  def serializable_hash(options = {})
    hash = super(options.merge(:only => [ :id, :created_at, :updated_at, :url, :source_locale, :embed_data ], :methods => [ :display_url, :site_name, :user_name ]))
    hash[:user] = hash.delete(:user_name)
    hash
  end

  def to_param
    url
  end

  def self.embedly_api
    embedly_api = Embedly::API.new :user_agent => 'Mozilla/5.0 (compatible; mytestapp/1.0; my@email.com)', :key => ENV['EMBEDLY_KEY']
  end

  def embedly_api
    self.class.embedly_api
  end

  private

  def default_values
    # add default values here
  end

  def parse_and_normalize_url
    self.url = self.class.parse_and_normalize(url)
  end

  def self.parse_and_normalize(url)
    uri = Addressable::URI.heuristic_parse(url)
    uri && uri.normalize.to_s
  end

  def get_embed_data
    obj = embedly_api.oembed :url => url
    self.embed_data = obj[0].marshal_dump
  end

  def title_present_in_source_locale
    return unless status > 0
    Globalize.with_locale(source_locale) do
      errors.add(:title, I18n.t('errors.messages.blank_in_lang', lang: I18n.t(source_locale))) unless title.present?
    end
  end
end
