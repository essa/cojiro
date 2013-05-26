class RemoveLinkCothreadAssociation < ActiveRecord::Migration
  def up
    remove_index :links, :cothread_id
    remove_column :links, :cothread_id
  end

  def down
    add_index :links, :cothread_id
    add_column :links, :cothread_id, :integer
  end
end
