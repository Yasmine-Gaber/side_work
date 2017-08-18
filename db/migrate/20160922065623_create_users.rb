class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :country_id
      t.integer :role_id

      t.timestamps null: false
    end
  end
end
