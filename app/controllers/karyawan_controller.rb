class KaryawanController < ApplicationController
  before_action :set_karyawan, only: %i[show update destroy]

  # GET /karyawan
  def index
    @karyawan, filtered = Karyawan.apply_filters(params)

    # Default sorting by ID ascending
    @karyawan = @karyawan.order(id: :asc)

    # If filters were applied and no results found, return error
    if filtered && @karyawan.empty?
      render json: { 
        error: "No exact match found for the given criteria",
        message: "Please ensure your search criteria exactly matches the records in the database"
      }, status: :not_found
    else
      # Map to the desired JSON structure
      render json: @karyawan.map { |karyawan| format_karyawan(karyawan) }
    end
  end

  # GET /karyawan/:id
  def show
    render json: format_karyawan(@karyawan)
  end

  # POST /karyawan
  def create
    @karyawan = Karyawan.new(karyawan_params)

    if @karyawan.save
      render json: format_karyawan(@karyawan), status: :created, location: @karyawan
    else
      render json: @karyawan.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /karyawan/:id
  def update
    Rails.logger.info "Received Params: #{params.inspect}"
    if @karyawan.update(karyawan_params)
      Rails.logger.info "Updated Karyawan: #{@karyawan.inspect}"
      render json: format_karyawan(@karyawan)
    else
      Rails.logger.error "Update Failed: #{@karyawan.errors.full_messages}"
      render json: @karyawan.errors, status: :unprocessable_entity
    end
  end
  
  # DELETE /karyawan/:id (soft delete)
  def destroy
    @karyawan.soft_delete
    head :no_content
  end

  def managers
    @managers = Karyawan.managers.select(:id, :name)
    Rails.logger.info "Managers: #{@managers.inspect}"
    render json: @managers
  end
    

  private

  def set_karyawan
    # Allow finding both active and deleted records
    @karyawan = Karyawan.unscoped.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Karyawan record not found" }, status: :not_found
  end

  def karyawan_params
    # Hapus parameter yang tidak diinginkan
    filtered_params = params.except(:controller, :action, :id, :karyawan)
    
    # Permit hanya parameter yang diinginkan
    filtered_params.permit(
      :name, :email, :phone, :tanggal_lahir, 
      :alamat, :tanggal_masuk, :departemen_id, :jabatan_id, 
      :status, :deleted
    )
  end
  # Custom method to format karyawan data to match the frontend interface
  def format_karyawan(karyawan)
    {
      id: karyawan.id.to_s,
      name: karyawan.name,
      position: karyawan.jabatan&.nama_jabatan || karyawan.jabatan_id.to_s,
      department: karyawan.departemen&.name || karyawan.departemen_id.to_s,
      email: karyawan.email,
      phone: karyawan.phone,
      status: karyawan.status
    }
  end
end