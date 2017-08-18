class DeleteTeamColumnFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :team, :string
  end
end
