# app/controllers/concerns/query_param_check_jabatan.rb
module QueryParamCheckJabatan
  extend ActiveSupport::Concern

  included do
    before_action :check_query_params, only: [ :index ]
  end

  private

  def allowed_query_params
    %w[nama_jabatan]
  end

  def check_query_params
    invalid_params = params.keys - allowed_query_params - [ "controller", "action" ]
    if invalid_params.any?
      render json: { error: "Invalid parameter(s): #{invalid_params.join(', ')}" }, status: :bad_request
    end
  end

  def filter_jabatan(scope)
    scope = scope.by_nama(params[:nama_jabatan]) if params[:nama_jabatan].present?
    scope
  end
end
