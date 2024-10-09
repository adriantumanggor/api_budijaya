require "test_helper"

class DepartemenControllerTest < ActionDispatch::IntegrationTest
  setup do
    @departeman = departemen(:one)
  end

  test "should get index" do
    get departemen_url, as: :json
    assert_response :success
  end

  test "should create departeman" do
    assert_difference("Departeman.count") do
      post departemen_url, params: { departeman: { nama_departemen: @departeman.nama_departemen } }, as: :json
    end

    assert_response :created
  end

  test "should show departeman" do
    get departeman_url(@departeman), as: :json
    assert_response :success
  end

  test "should update departeman" do
    patch departeman_url(@departeman), params: { departeman: { nama_departemen: @departeman.nama_departemen } }, as: :json
    assert_response :success
  end

  test "should destroy departeman" do
    assert_difference("Departeman.count", -1) do
      delete departeman_url(@departeman), as: :json
    end

    assert_response :no_content
  end
end
