class Cothread < ActiveRecord::Base
  attr_accessible :title, :summary, :source_language

  translates :title, :summary

  #validations
  validates :user, :presence => :true
  validates :title, :presence => :true #, :if => :in_original_language?

  #associations
  belongs_to :user

#  def in_original_language?
#    (self.original_language == Globalize.locale.to_s) || (self.original_language == nil)
#  end

end
