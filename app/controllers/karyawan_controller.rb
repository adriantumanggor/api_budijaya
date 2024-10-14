# app/controllers/karyawan_controller.rb
class KaryawanController < ApplicationController
  before_action :set_karyawan, only: %i[ show update destroy ]
  before_action :check_query_params, only: [:index]
  before_action :check_body_params, only: %i[ create update ]

  # GET /karyawan
  def index
    @karyawan = Karyawan.all
    @karyawan = @karyawan.by_nama_lengkap(params[:nama]) if params[:nama].present?
    @karyawan = @karyawan.by_email(params[:email]) if params[:email].present?
    @karyawan = @karyawan.by_departemen(params[:departemen_id]) if params[:departemen_id].present?
    @karyawan = @karyawan.by_jabatan(params[:jabatan_id]) if params[:jabatan_id].present?
    @karyawan = @karyawan.by_status(params[:status]) if params[:status].present?
    # @karyawan = @karyawan.by_nomor_telepon(params[:nomor_telepon]) if params[:nomor_telepon].present?
    # @karyawan = @karyawan.by_tanggal_lahir(params[:tanggal_lahir]) if params[:tanggal_lahir].present?
    # @karyawan = @karyawan.by_alamat(params[:alamat]) if params[:alamat].present?
    # @karyawan = @karyawan.by_tanggal_masuk(params[:tanggal_masuk]) if params[:tanggal_masuk].present?


    render json: @karyawan
  end

  # GET /karyawan/1
  def show
    render json: @karyawan
  end

  # POST /karyawan
  def create
    @karyawan = Karyawan.new(karyawan_params)

    if @karyawan.save
      render json: @karyawan, status: :created, location: @karyawan
    else
      render json: @karyawan.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /karyawan/1
  def update
    if @karyawan.update(karyawan_params)
      render json: @karyawan
    else
      render json: @karyawan.errors, status: :unprocessable_entity
    end
  end

  # DELETE /karyawan/1
  def destroy
    @karyawan.destroy!
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

    def allowed_query_params
      %w[nama email departemen_id jabatan_id status]
    end

    def check_query_params
      invalid_params = params.keys - allowed_query_params - ['controller', 'action']
      if invalid_params.any?
        render json: { error: "Invalid parameter(s): #{invalid_params.join(', ')}" }, status: :bad_request
      end
    end

    def check_body_params
      allowed_params = karyawan_params.keys
      incoming_params = params[:karyawan]&.keys || []

      extra_params = incoming_params - allowed_params

      if extra_params.any?
        render json: { error: "Unpermitted parameter(s): #{extra_params.join(', ')}" }, status: :bad_request
      end
    end
end