class DepartemenController < ApplicationController
  before_action :set_departemen, only: %i[show update destroy]

  def index
    @departemen_with_manager = Departemen.with_manager_name

    render json: @departemen_with_manager.map { |departemen_with_manager| format_karyawan(departemen_with_manager) }
  end

  def show
    render json: @departemen
  end

  def create
    @departemen = Departemen.new(departemen_params)
    if @departemen.save
      render json: @departemen, status: :created, location: @departemen
    else
      render json: @departemen.errors, status: :unprocessable_entity
    end
  end

  def update
    if @departemen.update(departemen_params)
      render json: @departemen
    else
      render json: @departemen.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @departemen.destroy
    head :no_content
  end

  private

  def set_departemen
    @departemen = Departemen.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Departemen record not found" }, status: :not_found
  end

  def departemen_params
    params.permit(:manager_id)
  end

  def format_karyawan(departemen)
    {
      id: departemen.id.to_s,
      name: departemen.name,
      manager_name: departemen.manager_name,
      manager_id: departemen.manager_id
    }
  end
end
