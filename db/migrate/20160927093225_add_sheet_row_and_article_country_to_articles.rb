class AddSheetRowAndArticleCountryToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :sheet_row, :integer
    add_column :articles, :article_country_id, :integer
  end
end
