class AddTargetToInterests < ActiveRecord::Migration
  def change
    add_column :interests, :daily_target, :integer
    add_column :interests, :weekly_target, :integer
    add_column :interests, :monthly_target, :integer
  end
end
