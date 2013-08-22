class ChangeLinksExtractDataToText < ActiveRecord::Migration
  def up
    change_column :links, :extract_data, :text
  end

  def down
    change_column :links, :extract_data, :string
  end
end
