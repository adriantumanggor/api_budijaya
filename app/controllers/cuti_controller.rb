class CutiController < ApplicationController
  before_action :set_cuti, only: %i[show edit update destroy]

  # GET /cuti
  def index
    @cuti = Cuti.all
  end

  # GET /cuti/:id
  def show
  end

  # GET /cuti/new
  def new
    @cuti = Cuti.new
  end

  # POST /cuti
  def create
    @cuti = Cuti.new(cuti_params)

    if @cuti.save
      redirect_to @cuti, notice: 'Cuti was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /cuti/:id/edit
  def edit
  end

  # PATCH/PUT /cuti/:id
  def update
    if @cuti.update(cuti_params)
      redirect_to @cuti, notice: 'Cuti was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /cuti/:id
  def destroy
    @cuti.destroy
    redirect_to cuti_index_path, notice: 'Cuti was successfully deleted.'
  end

  private

  # Find the cuti record by ID
  def set_cuti
    @cuti = Cuti.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to cuti_index_path, alert: 'Cuti not found.'
  end

  # Strong parameters
  def cuti_params
    params.require(:cuti).permit(:karyawan_id, :tanggal_mulai, :tanggal_selesai, :jenis_cuti, :status)
  end
end
  