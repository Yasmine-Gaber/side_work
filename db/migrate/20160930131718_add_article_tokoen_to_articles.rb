class AddArticleTokoenToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :article_token, :string
  end
end
