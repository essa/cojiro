class AddUrlIndexToLinks < ActiveRecord::Migration
  def self.up
    add_index :links, :url, :unique => true
  end

  def self.down
    remove_index :links, :url
  end
end
