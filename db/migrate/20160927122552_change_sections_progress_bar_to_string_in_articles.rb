class ChangeSectionsProgressBarToStringInArticles < ActiveRecord::Migration
  def change
    change_column :articles, :sections_progress_bar, :string
  end
end
