class AddApprovalCommentsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :approval_comments, :text
  end
end
