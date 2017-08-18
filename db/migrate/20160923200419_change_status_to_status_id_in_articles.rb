class ChangeStatusToStatusIdInArticles < ActiveRecord::Migration
  def change
    rename_column :articles, :status, :status_id
  end
end
