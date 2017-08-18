class CreateMessageLogs < ActiveRecord::Migration
  def change
    create_table :message_logs do |t|
      t.string :log_type
      t.string :description
      t.integer :article_id

      t.timestamps null: false
    end
  end
end
