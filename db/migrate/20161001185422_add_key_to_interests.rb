class AddKeyToInterests < ActiveRecord::Migration
  def change
    add_column :interests, :key, :string
  end
end
