module QueryParamChecker
  extend ActiveSupport::Concern

  included do
    before_action :check_query_params, only: [ :index ]
  end

  private

  def allowed_query_params
    %w[nama email departemen_id jabatan_id status]
  end

  def check_query_params
    invalid_params = params.keys - allowed_query_params - [ "controller", "action" ]
    if invalid_params.any?
      render json: { error: "Invalid parameter(s): #{invalid_params.join(', ')}" }, status: :bad_request
    end
  end
end
