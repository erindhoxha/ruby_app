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
 
end