class Comment < ActiveRecord::Base
  belongs_to :cothread
  belongs_to :link
  attr_accessible :text, :link_id

  validates :cothread_id, :presence => true, :uniqueness => { :scope => :link_id }

  def serializable_hash(options = {})
    super(options.merge(:only => [:id, :text, :created_at, :updated_at],
                        :include => [ :link ]))
  end
end
