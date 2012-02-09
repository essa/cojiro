class CreateCothreads < ActiveRecord::Migration

  def up
    create_table :cothreads do |t|
      t.string  :original_language, :limit => 2
      t.integer :user_id

      t.timestamps
    end
    Cothread.create_translation_table! :title => :string, :summary => :text
  end

  def down
    drop_table :cothreads
    Cothread.drop_translation_table!
  end

end
