class AddColumnsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :article_type_id, :integer 
    add_column :articles, :english_title, :string 
    add_column :articles, :original_link, :string 
    add_column :articles, :initial_title, :string 
    add_column :articles, :suggested_idea, :text 
    add_column :articles, :incident_date, :datetime 
    add_column :articles, :incident_country_id, :integer 
    add_column :articles, :processing_point_of_view, :text 
    add_column :articles, :why_publish, :text 
    add_column :articles, :resources, :text 
    add_column :articles, :resources_links, :text 
    add_column :articles, :execution_method, :integer 
    add_column :articles, :materials, :integer 
    add_column :articles, :final_title, :string 
    add_column :articles, :translated_words_count, :integer 
    add_column :articles, :original_words_count, :integer 
  end
end
