# app/controllers/karyawan_controller.rb
class KaryawanController < ApplicationController
  include QueryParamCheckKaryawan
  before_action :set_karyawan, only: %i[show update destroy]
  before_action :check_body_params, only: %i[create update]

  # GET /karyawan
  def index
    filter_karyawan
    render json: @karyawan
  end

  # GET /karyawan/1
  def show
    render json: @karyawan
  end

  # POST /karyawan
  def create
    @karyawan = Karyawan.new(karyawan_params)
    render_response(@karyawan.save ? @karyawan : @karyawan.errors, :created)
  end

  # PATCH/PUT /karyawan/1
  def update
    render_response(@karyawan.update(karyawan_params) ? @karyawan : @karyawan.errors)
  end

  # DELETE /karyawan/1
  def destroy
    @karyawan.destroy!
    head :no_content
  end

  private

  def set_karyawan
    @karyawan = Karyawan.find(params[:id])
  end

  def karyawan_params
    params.require(:karyawan).permit(
      :nama_lengkap,
      :email,
      :nomor_telepon,
      :tanggal_lahir,
      :alamat,
      :tanggal_masuk,
      :departemen_id,
      :jabatan_id,
      :status
    )
  end

  def filter_karyawan
    @karyawan = Karyawan.all
    %i[nama email departemen_id jabatan_id status].each do |param|
      @karyawan = @karyawan.public_send("by_#{param}", params[param]) if params[param].present?
    end
  end

  def render_response(resource, status = :ok)
    if resource.is_a?(ActiveRecord::Base) && resource.persisted?
      render json: resource, status: status
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end
end
