class AddApprovalStatusToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :approval_status, :integer, default: 0
  end
end
