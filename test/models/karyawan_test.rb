require "rails_helper"

RSpec.describe "Gaji API", type: :request do
  let!(:karyawan) { create(:karyawan) }
  let!(:gaji) { create(:gaji, karyawan: karyawan) }

  describe "POST /gaji" do
    context "with valid parameters" do
      it "creates a new Gaji" do
        expect {
          post "/gaji", params: { gaji: { bulan: "2024-10", gaji_pokok: 5000, tunjangan: 1000, potongan: 500, total_gaji: 5500, karyawan_id: karyawan.id } }
        }.to change(Gaji, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable entity" do
        post "/gaji", params: { gaji: { bulan: "", gaji_pokok: -1 } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /gaji" do
    it "returns all Gaji records" do
      get "/gaji"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "PATCH /gaji/:id" do
    it "updates the Gaji record" do
      patch "/gaji/#{gaji.id}", params: { gaji: { gaji_pokok: 6000 } }
      gaji.reload
      expect(gaji.gaji_pokok).to eq(6000)
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /gaji/:id" do
    it "deletes the Gaji record" do
      expect {
        delete "/gaji/#{gaji.id}"
      }.to change(Gaji, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "GET /gaji by scope" do
    it "filters by karyawan" do
      get "/gaji?karyawan_id=#{karyawan.id}"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).first["karyawan_id"]).to eq(karyawan.id)
    end
  end
end
