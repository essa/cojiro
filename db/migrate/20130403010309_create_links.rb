class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url
      t.string :title
      t.text :summary
      t.belongs_to :user
      t.belongs_to :cothread
      t.text :embed_data

      t.timestamps
    end
    add_index :links, :user_id
    add_index :links, :cothread_id
  end
end
