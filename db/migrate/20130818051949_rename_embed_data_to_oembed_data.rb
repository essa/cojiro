class RenameEmbedDataToOembedData < ActiveRecord::Migration
  def change
    rename_column :links, :embed_data, :oembed_data
  end
end
