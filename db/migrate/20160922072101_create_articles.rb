class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :line_manager_id
      t.integer :status
      t.string :title
      t.datetime :start_date
      t.datetime :deadline
      t.datetime :publish_date
      t.integer :progress_bar
      t.integer :editor_id
      t.integer :reporter_id
      t.integer :assignment_id
      t.string :drive_link
      t.integer :interest_id
      t.integer :sections_progress_bar
      t.string :cms_link
      t.text :notes

      t.timestamps null: false
    end
  end
end
