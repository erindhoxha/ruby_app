require "test_helper"

class CreateCategoryTest < ActionDispatch::IntegrationTest
    setup do
    @admin_user = User.create(username: "johndoe", email: "johndoe@test.com", 
                              password: "genericpassword", admin: true)
  end
  test "get new category form and create category" do
    sign_in_as(@admin_user)
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

  test "get new category form and reject invalid category" do
    sign_in_as(@admin_user)
    get "/categories/new"
    assert_response :success
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: " " } }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
  end
end
