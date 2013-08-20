class AddExtractDataToLinks < ActiveRecord::Migration
  def change
    add_column :links, :extract_data, :string
  end
end
