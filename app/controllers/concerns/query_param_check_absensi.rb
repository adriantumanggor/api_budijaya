# app/controllers/concerns/query_param_check_absensi.rb
module QueryParamCheckAbsensi
  extend ActiveSupport::Concern

  included do
    before_action :check_query_params, only: [:index]
  end

  private

  def allowed_query_params
    %w[karyawan_id tanggal waktu_masuk waktu_keluar status_absensi]
  end

  def check_query_params
    invalid_params = params.keys - allowed_query_params - ["controller", "action"]
    if invalid_params.any?
      render json: { error: "Invalid parameter(s): #{invalid_params.join(', ')}" }, status: :bad_request
    end
  end

  def filter_absensi(scope)
    scope = scope.by_karyawan(params[:karyawan_id]) if params[:karyawan_id].present?
    scope = scope.by_tanggal(params[:tanggal]) if params[:tanggal].present?
    scope = scope.by_waktu_masuk(params[:waktu_masuk]) if params[:waktu_masuk].present?
    scope = scope.by_waktu_keluar(params[:waktu_keluar]) if params[:waktu_keluar].present?
    scope = scope.by_status_absensi(params[:status_absensi]) if params[:status_absensi].present?
    scope
  end
end