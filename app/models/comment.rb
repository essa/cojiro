class Comment < ActiveRecord::Base
  belongs_to :cothread
  belongs_to :link
  attr_accessible :text

  def as_json(options = {})
    json = super(options.merge(:include => [ :link ]))
  end
end
