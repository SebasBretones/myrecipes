class ChangeRecipes < ActiveRecord::Migration[5.2]
  def change
    rename_column :recipes, :text, :description
    change_column :recipes, :description, :text
  end
end
