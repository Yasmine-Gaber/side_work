class CreateArticlesPersonas < ActiveRecord::Migration
  def change
    create_table :articles_personas do |t|
      t.integer :article_id
      t.integer :persona_id
    end
  end
end
