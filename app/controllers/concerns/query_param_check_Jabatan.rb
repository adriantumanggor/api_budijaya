module QueryParamCheckJabatan
  extend ActiveSupport::Concern

  included do
    before_action :check_jabatan_param, only: :index
    before_action :check_query_params, only: :index
  end

  private

  def check_jabatan_param
    if params[:nama].present? && params[:nama].strip.empty?
      render json: { error: "Query parameter 'nama' cannot be blank" }, status: :unprocessable_entity
    end
  end

  def allowed_query_params
    %w[nama]
  end

  def check_query_params
    invalid_params = params.keys - allowed_query_params - [ "controller", "action" ]
    if invalid_params.any?
      render json: { error: "Invalid parameter(s): #{invalid_params.join(', ')}" }, status: :bad_request
    end
  end
end
