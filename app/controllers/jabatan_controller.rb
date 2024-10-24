class JabatanController < ApplicationController
  before_action :set_jabatan, only: %i[show update destroy]

  def index
    @jabatan, filtered = Jabatan.apply_filters(params)

    # Default sorting by ID ascending
    @jabatan = @jabatan.order(id: :asc)

    # If filters were applied and no results found, return error
    if filtered && @jabatan.empty?
      render json: { 
        error: "No exact match found for the given criteria",
        message: "Please ensure your search criteria exactly matches the records in the database"
      }, status: :not_found
    else
      render json: @jabatan
    end
  end

  def show
    render json: @jabatan
  end

  def create
    @jabatan = Jabatan.new(jabatan_params)

    if @jabatan.save
      render json: @jabatan, status: :created, location: @jabatan
    else
      render json: @jabatan.errors, status: :unprocessable_entity
    end
  end

  def update
    if @jabatan.update(jabatan_params)
      render json: @jabatan
    else
      render json: @jabatan.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @jabatan.destroy
  end

  private

  def set_jabatan
    @jabatan = Jabatan.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Jabatan record not found" }, status: :not_found
  end

  def jabatan_params
    params.require(:jabatan).permit(:nama_jabatan)
  end
end
