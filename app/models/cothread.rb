class Cothread < ActiveRecord::Base
  translates :title, :summary

  #validations
#  validates :title, :presence => :true, :if => :in_original_language?

  #associations
  belongs_to :user

  def in_original_language?
    (self.original_language == Globalize.locale.to_s) || (self.original_language == nil)
  end

end
