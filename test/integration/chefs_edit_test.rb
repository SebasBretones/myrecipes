require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
  
    @chef = Chef.create!(chefname: "sebastian", email: "sebastian@example.com", password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "paco", email: "paco@example.com", password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "paco1", email: "paco1@example.com", password: "password", password_confirmation: "password", admin: true)
  end

  test "reject an invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: {chef: {chefname:"", email: "sebastian@example.com"}}
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'  
  end

  test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: {chef: {chefname:"sebastian1", email: "sebastian1@example.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "sebastian1", @chef.chefname
    assert_match "sebastian1@example.com", @chef.email
  end

  test "accept edit atempt by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: {chef: {chefname:"sebastian3", email: "sebastian2@example.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "sebastian3", @chef.chefname
    assert_match "sebastian2@example.com", @chef.email

  end

  test "redirect edit attempt by another non-admin user" do
    sign_in_as(@chef2, "password")
    updated_name = "joe"
    updated_email = "joe@example.com"
    patch chef_path(@chef), params: {chef: {chefname: updated_name, email: updated_email}}
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "sebastian", @chef.chefname
    assert_match "sebastian@example.com", @chef.email

  end

end
