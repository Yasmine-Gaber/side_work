class AddKeyToArticleTypes < ActiveRecord::Migration
  def change
    add_column :article_types, :key, :string
  end
end
