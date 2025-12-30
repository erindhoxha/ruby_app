require "test_helper"

class CreateCategoryTest < ActionDispatch::IntegrationTest
  test "the truth" do
    assert true
  end
  test "get new category form and create category" do
    get "/categories/new"
    assert_response :success
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: { name: "Electronics" } }
      assert_response :redirect
  end
    follow_redirect!
    assert_response :success
    assert_match "Electronics", response.body
  end
end
