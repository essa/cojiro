class AddSourceLocaleToComments < ActiveRecord::Migration
  def change
    add_column :comments, :source_locale, :string, :limit => 2
  end
end
