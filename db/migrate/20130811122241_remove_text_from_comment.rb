class RemoveTextFromComment < ActiveRecord::Migration
  def up
    remove_column :comments, :text
  end

  def down
    add_column :comments, :text, :text
  end
end
