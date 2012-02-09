class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.text :profile
      t.string :location
      t.string :mysite
      t.string :fullname

      t.timestamps
    end
  end
end
