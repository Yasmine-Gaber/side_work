class AddColumnsToArticleTypes < ActiveRecord::Migration
  def change
    add_column :article_types, :daily_target, :integer
    add_column :article_types, :weekly_target, :integer
    add_column :article_types, :monthly_target, :integer
  end
end
