class AddSourceLocaleToLinks < ActiveRecord::Migration
  def change
    add_column :links, :source_locale, :string, :limit => 2
  end
end
