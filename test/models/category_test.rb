require "test_helper"

class CategoryTest < ActiveSupport::TestCase
 # "Category should be valid"
 test "category should be valid" do
  @category = Category.new(name: "Sports")
  assert @category.valid?
 end

 test "category name should be present" do
  @category = Category.new(name: "");
  assert @category.valid?
 end
 
end