class RenameSourceLanguageToSourceLocale < ActiveRecord::Migration
  def up
    rename_column :cothreads, :source_language, :source_locale
  end

  def down
    rename_column :cothreads, :source_locale, :source_language
  end
end
