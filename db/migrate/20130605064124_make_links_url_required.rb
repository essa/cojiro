class MakeLinksUrlRequired < ActiveRecord::Migration
  def up
    change_column :links, :url, :string, :null => false
  end

  def down
    change_column :links, :url, :string, :null => true
  end
end
