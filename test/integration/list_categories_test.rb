require "test_helper"

class ListCategoriesTest < ActionDispatch::IntegrationTest
  def setup
    @category = Category.create(name: "Sports")
    @category = Category.create(name: "Electronics")
  end

  test "it should have 2 categories and show listing" do
    get '/categories'
    
  end
end
