module QueryParamCheckDepartemen
  extend ActiveSupport::Concern

  included do
    before_action :check_query_params, only: [:index]
  end

  private

  def allowed_query_params
    %w[nama_departemen]
  end

  def check_query_params
    invalid_params = params.keys - allowed_query_params - %w[controller action]
    if invalid_params.any?
      render json: { error: "Invalid parameter(s): #{invalid_params.join(', ')}" }, status: :bad_request
    end
  end

  def filter_departemen(scope)
    scope = scope.by_nama(params[:nama_departemen]) if params[:nama_departemen].present?
    scope
  end
end