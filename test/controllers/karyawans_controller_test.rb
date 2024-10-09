require "test_helper"

class KaryawansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @karyawan = karyawans(:one)
  end

  test "should get index" do
    get karyawans_url, as: :json
    assert_response :success
  end

  test "should create karyawan" do
    assert_difference("Karyawan.count") do
      post karyawans_url, params: { karyawan: {} }, as: :json
    end

    assert_response :created
  end

  test "should show karyawan" do
    get karyawan_url(@karyawan), as: :json
    assert_response :success
  end

  test "should update karyawan" do
    patch karyawan_url(@karyawan), params: { karyawan: {} }, as: :json
    assert_response :success
  end

  test "should destroy karyawan" do
    assert_difference("Karyawan.count", -1) do
      delete karyawan_url(@karyawan), as: :json
    end

    assert_response :no_content
  end
end
