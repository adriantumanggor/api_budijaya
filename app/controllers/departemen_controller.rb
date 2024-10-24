class DepartemenController < ApplicationController
  before_action :set_departemen, only: %i[show update destroy]

  def index
    @departemen, filtered = Departemen.apply_filters(params)

    # Default sorting by ID ascending
    @departemen = @departemen.order(id: :asc)

    # If filters were applied and no results found, return error
    if filtered && @departemen.empty?
      render json: { 
        error: "No exact match found for the given criteria",
        message: "Please ensure your search criteria exactly matches the records in the database"
      }, status: :not_found
    else
      render json: @departemen
    end
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
    params.require(:departemen).permit(:nama_departemen)
  end
end
