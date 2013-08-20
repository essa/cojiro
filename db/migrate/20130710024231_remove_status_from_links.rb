class RemoveStatusFromLinks < ActiveRecord::Migration
  def up
    remove_column :links, :status
  end

  def down
    add_column :links, :status, :integer, :null => false, :default => 0
  end
end
