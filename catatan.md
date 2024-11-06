tadi kita generate schema.rb menggunakan rakefile dengan command

rake db:schema:dump

dan menghasilkan schema.rb di db/schema.rb
setelah itu kita menggunakan command scaffold untuk generate MVC dari database kita

menambahkan:

1. Trigger Function di PostgreSQL untuk Membersihkan waktu_masuk dan waktu_keluar

Kita akan membuat trigger function yang akan berjalan setiap kali ada insert atau update pada tabel absensi. Jika status absensi karyawan adalah izin, sakit, atau alfa, maka nilai dari waktu_masuk dan waktu_keluar akan dikosongkan secara otomatis.
SQL Script untuk Trigger:

sql

-- Fungsi Trigger untuk mengosongkan waktu_masuk dan waktu_keluar jika status_absensi adalah izin, sakit, atau alfa
CREATE OR REPLACE FUNCTION clear_time_if_absent()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status_absensi IN ('izin', 'sakit', 'alfa') THEN
        NEW.waktu_masuk := NULL;
        NEW.waktu_keluar := NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Membuat Trigger pada tabel absensi
CREATE TRIGGER trigger_clear_time
BEFORE INSERT OR UPDATE ON absensi
FOR EACH ROW
EXECUTE FUNCTION clear_time_if_absent();

Dengan trigger ini, setiap kali data absensi baru dimasukkan atau diperbarui, jika status absensinya "tidak hadir", maka kolom waktu_masuk dan waktu_keluar akan direset (kosong).

2. Memastikan Format Tanggal atau Bulan
Misalnya, jika kolom bulan harus disimpan dalam format yang konsisten, seperti "YYYY-MM" (contoh: 2024-10), kamu bisa membuat trigger untuk memastikan bahwa inputan ke kolom bulan selalu dalam format tersebut, bahkan jika user memasukkan format lain:
CREATE OR REPLACE FUNCTION format_bulan_trigger()
RETURNS TRIGGER AS $$
BEGIN
    -- Mengubah inputan bulan menjadi format 'YYYY-MM'
    NEW.bulan := TO_CHAR(TO_DATE(NEW.bulan, 'YYYY-MM-DD'), 'YYYY-MM');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER format_bulan_before_insert
BEFORE INSERT OR UPDATE ON gaji
FOR EACH ROW
EXECUTE FUNCTION format_bulan_trigger();

3. Trigger untuk Mencegah Absensi Ganda

Trigger ini akan memeriksa apakah karyawan sudah memiliki absensi pada tanggal yang sama. Jika sudah ada, maka absensi baru akan dibatalkan.
CREATE OR REPLACE FUNCTION prevent_duplicate_absensi()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM absensi
        WHERE karyawan_id = NEW.karyawan_id
        AND tanggal = NEW.tanggal
    ) THEN
        RAISE EXCEPTION 'Absensi sudah ada untuk karyawan ini pada tanggal tersebut.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_duplicate_absensi
BEFORE INSERT ON absensi
FOR EACH ROW
EXECUTE FUNCTION prevent_duplicate_absensi();

4. pembuatan otomatis alpha untuk setiap karyawan yang tidak melakukan absen di hari kerja kerja
-- Step 1: Create the extension
CREATE EXTENSION pg_cron;

-- Step 2: Create the workday check function
CREATE OR REPLACE FUNCTION is_workday(check_date DATE)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXTRACT(DOW FROM check_date) BETWEEN 1 AND 5;
END;
$$ LANGUAGE plpgsql;

-- Step 3: Create the function to insert alpha records
CREATE OR REPLACE FUNCTION insert_alpha_records()
RETURNS void AS $$
DECLARE
    current_date_var DATE := CURRENT_DATE;
BEGIN
    -- Only proceed if today is a workday
    IF is_workday(current_date_var) THEN
        INSERT INTO absensi (karyawan_id, tanggal, status_absensi)
        SELECT 
            k.id,
            current_date_var,
            'alpha'
        FROM karyawan k
        WHERE k.status = 'aktif'
        AND NOT EXISTS (
            SELECT 1 
            FROM absensi a 
            WHERE a.karyawan_id = k.id 
            AND a.tanggal = current_date_var
        );
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Step 4: Schedule the job to run at 23:59 every day
SELECT cron.schedule('absent_check', '59 23 * * *', $$SELECT insert_alpha_records()$$);

-- Step 5: Verify the scheduled job
SELECT * FROM cron.job;


