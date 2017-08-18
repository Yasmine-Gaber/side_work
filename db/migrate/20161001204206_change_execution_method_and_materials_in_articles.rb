class ChangeExecutionMethodAndMaterialsInArticles < ActiveRecord::Migration
  def change
    change_column :articles, :execution_method, :string
    change_column :articles, :materials, :string
  end
end
