class Comment < ActiveRecord::Base
  belongs_to :cothread
  belongs_to :link, :autosave => true, :validate => false
  belongs_to :user
  attr_accessible :text, :link_id, :link_attributes

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
      # this is really ugly, but what it is basically doing is merging
      # translated attributes as hashes, and sending the result to
      # initialize_by_url. see at globalize_helpers.
      #
      # it would be much easier if #translated_attributes returned
      # a has of keys/values, but values are nil at this point
      # so it doesn't work.
      attributes_hash = link.attribute_names.map do |name|
        [ name, link.translated?(name) ? link.send("#{name}_translations") : link.send(name) ]
      end
      attrs = Hash[attributes_hash].delete_if { |_,v| v.nil? }
      new_link = Link.initialize_by_url(attrs.delete('url'), attrs)
      new_link.user_id = user_id
      if new_link.save
        self.link = new_link
      end
    end
  end
end
