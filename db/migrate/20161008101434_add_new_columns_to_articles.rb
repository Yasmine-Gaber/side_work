class AddNewColumnsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :details, :text
    add_column :articles, :publisher_id, :integer
    add_column :articles, :designer_id, :integer
    add_column :articles, :reporter_desk_notes, :text
    add_column :articles, :trans_desk_notes, :text
    add_column :articles, :reporter_notes, :text
    add_column :articles, :manager_notes, :text
    add_column :articles, :publish_flag, :boolean
  end
end
