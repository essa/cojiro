class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :text
      t.belongs_to :cothread
      t.belongs_to :link

      t.timestamps
    end
    add_index :comments, :cothread_id
    add_index :comments, :link_id
  end
end
