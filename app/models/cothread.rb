require 'globalize_helpers'

class Cothread < ActiveRecord::Base
  translates :title, :summary
  include GlobalizeHelpers

  attr_accessible :title, :summary, :source_locale

  #scopes
  scope :recent, order("cothreads.created_at DESC")

  #validations
  validates :user, :presence => true
  validates :source_locale, :presence => :true
  validate :title_present_in_source_locale

  #callbacks
  before_validation :default_values

  #associations
  belongs_to :user
  has_many :comments
  has_many :links, :through => :comments

  def serializable_hash(options = {})
    super(options.merge(:only => [:id, :created_at, :updated_at, :source_locale],
                        :include => [ :user, :comments ]))
  end

  def participants
    users_who_added_links = User.includes(links: :comments).where(comments: { cothread_id: id })
    users_who_added_comments = User.includes(:comments).where(comments: { cothread_id: id })
    (users_who_added_links + users_who_added_comments).uniq
  end

  private

  def default_values
    self.source_locale ||= I18n.locale.to_s
  end

  def title_present_in_source_locale
    Globalize.with_locale(source_locale) do
      errors.add(:title, I18n.t('errors.messages.blank')) unless self.title.present?
    end
  end
end
