class AddColumnsToPersonas < ActiveRecord::Migration
  def change
    add_column :personas, :daily_target, :integer
    add_column :personas, :weekly_target, :integer
    add_column :personas, :monthly_target, :integer
  end
end
