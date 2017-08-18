class CreateAccessibilityRulesRoles < ActiveRecord::Migration
  def change
    create_table :accessibility_rules_roles do |t|
      t.integer :accessibility_rule_id
      t.integer :role_id
    end
  end
end
