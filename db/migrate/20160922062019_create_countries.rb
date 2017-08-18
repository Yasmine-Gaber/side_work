class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name_en
      t.string :name_ar
      t.string :alpha3

      t.timestamps null: false
    end
  end
end
