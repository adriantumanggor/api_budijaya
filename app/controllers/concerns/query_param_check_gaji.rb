# app/controllers/concerns/query_param_check_gaji.rb
module QueryParamCheckGaji
  extend ActiveSupport::Concern

  included do
    before_action :check_query_params, only: [ :index ]
  end

  private

  def allowed_query_params
    %w[karyawan_id bulan gaji_pokok tunjangan potongan total_gaji
       min_gaji_pokok max_gaji_pokok min_tunjangan max_tunjangan
       min_potongan max_potongan min_total_gaji max_total_gaji]
  end

  def check_query_params
    invalid_params = params.keys - allowed_query_params - [ "controller", "action" ]
    if invalid_params.any?
      render json: { error: "Invalid parameter(s): #{invalid_params.join(', ')}" }, status: :bad_request
    end
  end

  def filter_gaji(scope)
    scope = scope.by_karyawan(params[:karyawan_id]) if params[:karyawan_id].present?
    scope = scope.by_bulan(params[:bulan]) if params[:bulan].present?

    %i[gaji_pokok tunjangan potongan total_gaji].each do |attribute|
      scope = apply_filter(scope, attribute)
    end

    scope
  end

  def apply_filter(scope, attribute)
    if params[attribute].present?
      scope.public_send("by_#{attribute}", params[attribute])
    elsif params["min_#{attribute}"].present? && params["max_#{attribute}"].present?
      scope.public_send("by_#{attribute}_range", params["min_#{attribute}"], params["max_#{attribute}"])
    else
      scope
    end
  end
end
