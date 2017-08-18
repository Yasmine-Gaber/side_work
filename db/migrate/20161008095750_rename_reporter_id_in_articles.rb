class RenameReporterIdInArticles < ActiveRecord::Migration
  def change
    rename_column :articles, :reporter_id, :user_id
  end
end
