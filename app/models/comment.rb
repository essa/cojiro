class Comment < ActiveRecord::Base
  belongs_to :cothread
  attr_accessible :text, :link_id
  belongs_to :link, :autosave => true, :validate => false
  belongs_to :user

  accepts_nested_attributes_for :link

  validates :cothread_id, :presence => true, :uniqueness => { :scope => :link_id }
  validates :user_id, :presence => true

  def serializable_hash(options = {})
    super(options.merge(:only => [:id, :text, :created_at, :updated_at],
                        :include => [ :link ]))
  end

  # ref: http://stackoverflow.com/questions/3579924/accepts-nested-attributes-for-with-find-or-create
  def autosave_associated_records_for_link
    if link
      # we need to do it this way (using send) because globalize3 does not
      # initialize translated attributes in link.attributes hash
      attrs = Hash[link.attribute_names.map { |name| [name, link.send(name)] }]
      attrs.delete_if { |_,v| v.nil? }
      new_link = Link.initialize_by_url(attrs.delete('url'), attrs)
      new_link.user_id = user_id
      if new_link.save
        self.link = new_link
      end
    end
  end
end
