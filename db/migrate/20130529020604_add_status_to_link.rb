class AddStatusToLink < ActiveRecord::Migration
  def change
    add_column :links, :status, :integer, :null => false, :default => 0
  end
end
