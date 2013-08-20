class RemoveTitleAndSummaryFromLinks < ActiveRecord::Migration
  def up
    remove_column :links, :title
    remove_column :links, :summary
  end

  def down
    add_column :links, :summary, :text
    add_column :links, :title, :string
  end
end
