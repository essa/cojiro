class AddTextTranslationTableToComments < ActiveRecord::Migration
  def up
    Comment.create_translation_table! :text => :text
  end

  def down
    Comment.drop_translation_table!
  end
end
