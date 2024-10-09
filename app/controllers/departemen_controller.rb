class DepartemenController < ApplicationController
  before_action :set_departeman, only: %i[ show update destroy ]

  # GET /departemen
  def index
    @departemen = Departeman.all

    render json: @departemen
  end

  # GET /departemen/1
  def show
    render json: @departeman
  end

  # POST /departemen
  def create
    @departeman = Departeman.new(departeman_params)

    if @departeman.save
      render json: @departeman, status: :created, location: @departeman
    else
      render json: @departeman.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /departemen/1
  def update
    if @departeman.update(departeman_params)
      render json: @departeman
    else
      render json: @departeman.errors, status: :unprocessable_entity
    end
  end

  # DELETE /departemen/1
  def destroy
    @departeman.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_departeman
      @departeman = Departeman.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def departeman_params
      params.require(:departeman).permit(:nama_departemen)
    end
end
