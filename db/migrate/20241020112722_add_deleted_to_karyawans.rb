class AddDeletedToKaryawans < ActiveRecord::Migration[7.2]
  def change
    add_column :karyawan, :deleted, :boolean, :default => false
  end
end
