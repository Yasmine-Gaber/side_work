class AddTitleArToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :title_ar, :string
  end
end
