class RenameOriginalLanguageToSourceLanguage < ActiveRecord::Migration
  def up
    rename_column :cothreads, :original_language, :source_language
  end

  def down
    rename_column :cothreads, :source_language, :original_language
  end
end
