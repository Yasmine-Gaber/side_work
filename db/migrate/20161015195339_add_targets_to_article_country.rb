class AddTargetsToArticleCountry < ActiveRecord::Migration
  def change
    add_column :article_countries, :daily_target, :integer
    add_column :article_countries, :weekly_target, :integer
    add_column :article_countries, :monthly_target, :integer
  end
end
