class CreateLinksTranslationTable < ActiveRecord::Migration
  def up
    Link.create_translation_table! :title => :string, :summary => :text
  end

  def down
    Link.drop_translation_table!
  end
end
