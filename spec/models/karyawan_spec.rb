require 'rails_helper'

RSpec.describe Karyawan, type: :model do
  # Association tests
  it { should belong_to(:departemen) }
  it { should belong_to(:jabatan) }
  it { should have_many(:absensi) }
  it { should have_many(:gaji) }

  # Validation tests
  it 'is valid with valid attributes' do
    karyawan = Karyawan.new(
      nama_lengkap: 'alek bijer',
      email: 'bijer@example.com',
      nomor_telepon: '1234567890',
      status: 'aktif'
    )
    expect(karyawan).to be_valid
  end

  it 'is not valid without a nama_lengkap' do
    karyawan = Karyawan.new(nama_lengkap: nil)
    expect(karyawan).not_to be_valid
  end

  it 'is not valid without an email' do
    karyawan = Karyawan.new(email: nil)
    expect(karyawan).not_to be_valid
  end

  it 'is not valid with a duplicate email' do
    Karyawan.create(nama_lengkap: 'Jackson Nicolas', email: 'john@example.com')
    karyawan = Karyawan.new(email: 'john@example.com')
    expect(karyawan).not_to be_valid
  end

  it 'is not valid if status is not in the list' do
    karyawan = Karyawan.new(status: 'unknown')
    expect(karyawan).not_to be_valid
  end

  it 'is valid with a status of aktif' do
    karyawan = Karyawan.new(status: 'aktif')
    expect(karyawan).to be_valid
  end

  it 'is valid with a status of nonaktif' do
    karyawan = Karyawan.new(status: 'nonaktif')
    expect(karyawan).to be_valid
  end

  # Scope tests
  describe 'scopes' do
    let!(:karyawan1) { Karyawan.create(nama_lengkap: 'Ali', email: 'ali@example.com') }
    let!(:karyawan2) { Karyawan.create(nama_lengkap: 'Bobi', email: 'bobi@example.com') }

    it 'filters by name' do
      expect(Karyawan.by_nama('Ali')).to include(karyawan1)
      expect(Karyawan.by_nama('Ali')).not_to include(karyawan2)
    end

    it 'filters by email' do
      expect(Karyawan.by_email('bobi@example.com')).to include(karyawan2)
      expect(Karyawan.by_email('bobi@example.com')).not_to include(karyawan1)
    end
  end
end
