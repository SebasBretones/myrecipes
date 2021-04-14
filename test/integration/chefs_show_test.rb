require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest
  
  def setup
  
    @chef = Chef.create!(chefname: "sebastian", email: "sebastian@example.com", password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "vegetable saute", description: "great vegetable saute, add vegetable and oil", chef: @chef)
    @recipe2 = @chef.recipes.build(name: "chicken saute", description: "great chicken dish")
    @recipe2.save
  end

  test "should get chefs show" do
    get chef_path(@chef)
    assert_template 'chefs/show'
    assert_select "a[href=?]", recipe_path(@recipe), @recipe.name
    assert_select "a[href=?]", recipe_path(@recipe2), @recipe2.name
    assert_match @recipe.description, response.body
    assert_match @recipe2.description, response.body
    assert_match @chef.chefname, response.body
  end


end
