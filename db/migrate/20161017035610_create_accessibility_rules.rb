class CreateAccessibilityRules < ActiveRecord::Migration
  def change
    create_table :accessibility_rules do |t|
      t.string :key
      t.string :name

      t.timestamps null: false
    end
  end
end
