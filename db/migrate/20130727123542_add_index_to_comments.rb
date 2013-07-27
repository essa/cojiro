class AddIndexToComments < ActiveRecord::Migration
  def change
    add_index :comments, [:cothread_id, :link_id], :unique => true
  end
end
