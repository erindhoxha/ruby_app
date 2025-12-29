require "test_helper"

class CategoryTest < ActiveSupport::TestCase
 # "Category should be valid"
 def setup
  @category = Category.new(name: "Electronics")
 end

 test "category should be valid" do
  assert @category.valid?
 end

 test "category name should be present" do
  @category.name = " "
  assert_not @category.valid?
 end

 test "name should be unique" do
  @category.save
  @category2 = Category.new(name: "Electronics")
  assert_not @category2.valid?
 end

 test "name should not be too long" do
  @category.name = "a" * 51
  assert_not @category.valid?
 end

 test "name should not be too short" do
  @category.name = "aa"
  assert_not @category.valid?
 end
 
end