class RemoveTitleColumnFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :title, :string
  end
end
