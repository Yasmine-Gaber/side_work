class AddTeamIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :team_id, :integer
  end
end
