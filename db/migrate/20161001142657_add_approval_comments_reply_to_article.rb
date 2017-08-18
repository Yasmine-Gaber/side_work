class AddApprovalCommentsReplyToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :approval_comments_reply, :string
  end
end
