class Comment < ActiveRecord::Base
  belongs_to :cothread
  belongs_to :link
  attr_accessible :text

  def as_json(options = {})
    json = super(options.merge(:only => [:id, :text, :created_at, :updated_at],
                               :include => [ :link ]))
  end
end
