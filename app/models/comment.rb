class Comment < ActiveRecord::Base
  belongs_to :cothread, :touch => true
  belongs_to :link, :autosave => true, :validate => false
  belongs_to :user
  attr_accessible :text, :link_id, :link_attributes

  accepts_nested_attributes_for :link

  validates :cothread_id, :presence => true, :uniqueness => { :scope => :link_id }
  validates :user_id, :presence => true

  def user_name
    user && user.name
  end

  def serializable_hash(options = {})
    super(options.merge(:only => [:id, :text, :created_at, :updated_at],
                        :include => [ :link ], :methods  => [ :user_name ]))
  end

  # ref: http://stackoverflow.com/questions/3579924/accepts-nested-attributes-for-with-find-or-create
  def autosave_associated_records_for_link
    if link
      attrs = link.untranslated_attributes.delete_if { |_,v| v.nil? }
      new_link = Link.initialize_by_url(attrs.delete('url'), attrs)
      new_link.merge_translations!(link)
      new_link.user_id = user_id
      if new_link.save
        self.link = new_link
      end
    end
  end
end
