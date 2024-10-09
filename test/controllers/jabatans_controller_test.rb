require "test_helper"

class JabatansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jabatan = jabatans(:one)
  end

  test "should get index" do
    get jabatans_url, as: :json
    assert_response :success
  end

  test "should create jabatan" do
    assert_difference("Jabatan.count") do
      post jabatans_url, params: { jabatan: { nama_jabatan: @jabatan.nama_jabatan } }, as: :json
    end

    assert_response :created
  end

  test "should show jabatan" do
    get jabatan_url(@jabatan), as: :json
    assert_response :success
  end

  test "should update jabatan" do
    patch jabatan_url(@jabatan), params: { jabatan: { nama_jabatan: @jabatan.nama_jabatan } }, as: :json
    assert_response :success
  end

  test "should destroy jabatan" do
    assert_difference("Jabatan.count", -1) do
      delete jabatan_url(@jabatan), as: :json
    end

    assert_response :no_content
  end
end
