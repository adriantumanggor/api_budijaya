# app/controllers/concerns/query_param_check_karyawan.rb
module QueryParamCheckKaryawan
  extend ActiveSupport::Concern

  included do
    before_action :check_query_params, only: [:index]
  end

  private

  def allowed_query_params
    %w[nama email nomor_telepon tanggal_lahir alamat tanggal_masuk departemen_id jabatan_id status]
  end

  def check_query_params
    invalid_params = params.keys - allowed_query_params - ["controller", "action"]
    if invalid_params.any?
      render json: { error: "Invalid parameter(s): #{invalid_params.join(', ')}" }, status: :bad_request
    end
  end

  def filter_karyawan(scope)
    scope = scope.by_nama(params[:nama]) if params[:nama].present?
    scope = scope.by_email(params[:email]) if params[:email].present?
    scope = scope.by_nomor_telepon(params[:nomor_telepon]) if params[:nomor_telepon].present?
    scope = scope.by_tanggal_lahir(params[:tanggal_lahir]) if params[:tanggal_lahir].present?
    scope = scope.by_alamat(params[:alamat]) if params[:alamat].present?
    scope = scope.by_tanggal_masuk(params[:tanggal_masuk]) if params[:tanggal_masuk].present?
    scope = scope.by_departemen_id(params[:departemen_id]) if params[:departemen_id].present?
    scope = scope.by_jabatan_id(params[:jabatan_id]) if params[:jabatan_id].present?
    scope = scope.by_status(params[:status]) if params[:status].present?
    scope
  end
end