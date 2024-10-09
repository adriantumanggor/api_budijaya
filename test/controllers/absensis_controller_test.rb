require "test_helper"

class AbsensisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @absensi = absensis(:one)
  end

  test "should get index" do
    get absensis_url, as: :json
    assert_response :success
  end

  test "should create absensi" do
    assert_difference("Absensi.count") do
      post absensis_url, params: { absensi: {} }, as: :json
    end

    assert_response :created
  end

  test "should show absensi" do
    get absensi_url(@absensi), as: :json
    assert_response :success
  end

  test "should update absensi" do
    patch absensi_url(@absensi), params: { absensi: {} }, as: :json
    assert_response :success
  end

  test "should destroy absensi" do
    assert_difference("Absensi.count", -1) do
      delete absensi_url(@absensi), as: :json
    end

    assert_response :no_content
  end
end
