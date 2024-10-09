require "test_helper"

class GajisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gaji = gajis(:one)
  end

  test "should get index" do
    get gajis_url, as: :json
    assert_response :success
  end

  test "should create gaji" do
    assert_difference("Gaji.count") do
      post gajis_url, params: { gaji: { bulan: @gaji.bulan, gaji_pokok: @gaji.gaji_pokok, karyawan_id: @gaji.karyawan_id, potongan: @gaji.potongan, total_gaji: @gaji.total_gaji, tunjangan: @gaji.tunjangan } }, as: :json
    end

    assert_response :created
  end

  test "should show gaji" do
    get gaji_url(@gaji), as: :json
    assert_response :success
  end

  test "should update gaji" do
    patch gaji_url(@gaji), params: { gaji: { bulan: @gaji.bulan, gaji_pokok: @gaji.gaji_pokok, karyawan_id: @gaji.karyawan_id, potongan: @gaji.potongan, total_gaji: @gaji.total_gaji, tunjangan: @gaji.tunjangan } }, as: :json
    assert_response :success
  end

  test "should destroy gaji" do
    assert_difference("Gaji.count", -1) do
      delete gaji_url(@gaji), as: :json
    end

    assert_response :no_content
  end
end
