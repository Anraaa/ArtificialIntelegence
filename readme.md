# Student Performance Predictor (Laravel Filament + Python API)

## 📖 Tentang Proyek

Student Performance Predictor adalah sebuah aplikasi web lengkap yang menunjukkan bagaimana mengintegrasikan model Machine Learning ke dalam aplikasi modern. Proyek ini terdiri dari dua komponen utama:

1. **Backend & Admin Panel (Laravel Filament)**: Sebuah panel admin yang elegan dan fungsional dibangun dengan Laravel dan Filament v3. Digunakan untuk mengelola data siswa (CRUD) dan sebagai antarmuka untuk memicu prediksi skor.

2. **API Machine Learning (Python Flask)**: Sebuah API service yang efisien dibangun dengan Python dan Flask. Service ini bertugas memuat model Machine Learning yang sudah dilatih dan melayani permintaan prediksi secara real-time.

Proyek ini adalah contoh sempurna dari arsitektur microservice di mana aplikasi web dan "otak" AI dipisahkan untuk skalabilitas dan kemudahan pengelolaan.

## ✨ Fitur Utama

- **Manajemen Siswa**: Operasi CRUD (Create, Read, Update, Delete) penuh untuk data siswa.
- **Prediksi Skor Real-time**: Tombol "Prediksi" di setiap baris data siswa untuk memanggil API Python dan mendapatkan prediksi skor secara instan.
- **Penyimpanan Hasil**: Hasil prediksi skor secara otomatis disimpan kembali ke database.
- **API Terpisah**: Layanan Machine Learning berjalan secara independen, memungkinkan pembaruan model tanpa mengganggu aplikasi web utama.

## 🏛️ Arsitektur Sistem
## 🏛️ Arsitektur Sistem

Aplikasi ini menggunakan arsitektur client-server di mana Laravel Filament bertindak sebagai client yang mengirimkan permintaan HTTP ke server API Python.

1. User berinteraksi dengan Panel Admin Filament.
2. Saat tombol "Prediksi" diklik, Laravel mengirimkan data siswa (jam belajar, kehadiran, partisipasi) melalui HTTP POST Request.
3. API Flask (Python) menerima request, memvalidasi data, dan memasukkannya ke dalam model Scikit-learn yang sudah dimuat.
4. API mengembalikan hasil prediksi dalam format JSON.
5. Laravel menerima respons JSON, menampilkan notifikasi ke user, dan memperbarui database dengan skor yang diprediksi.

## 🛠️ Teknologi yang Digunakan

| Komponen | Teknologi |
|----------|-----------|
| Backend & Admin Panel | PHP 8.1+, Laravel 10, Filament 3 |
| API Machine Learning | Python 3.9+, Flask, Waitress, Scikit-learn, Pandas, Joblib |
| Database | MySQL / PostgreSQL / SQLite |
| Lingkungan Development | Composer, NPM, Python venv |

## 🚀 Panduan Instalasi dan Setup

Untuk menjalankan proyek ini, Anda perlu menjalankan dua aplikasi terpisah: API Python dan Aplikasi Web Laravel.

### 📋 Prasyarat
- Git
- Docker & Docker Compose
- Python 3.9+
- PHP 8.1+
- Composer
- NPM

### Setup dengan Docker (Direkomendasikan)

#### 1. Clone Repository & Siapkan Konfigurasi
```bash
# Clone repository
git clone <repo_url>
cd ArtificialIntelegence

# Masuk ke direktori aplikasi
cd project/src

# Salin file environment untuk konfigurasi
cp .env.example .env
```

Setelah itu, buka file `.env` dan sesuaikan konfigurasi database (DB_DATABASE, DB_USERNAME, DB_PASSWORD) agar cocok dengan environment di file `docker-compose.yml`.

#### 2. Build & Jalankan Container Docker
```bash
# Kembali ke direktori utama
cd ..

# Build dan jalankan semua layanan
docker compose up -d --build
```

#### 3. Setup Aplikasi di Dalam Container
```bash
# Masuk ke container PHP
docker exec -it ai bash

# Install dependensi PHP
composer install

# Generate kunci aplikasi Laravel
php artisan key:generate

# Buat link dari storage ke folder public
php artisan storage:link

# Jalankan migrasi dan seeding database
php artisan migrate --seed

# Buat user admin
php artisan make:filament-user
```

#### 4. Atur Izin Akses Folder
```bash
chown -R www-data:www-data storage/*
chown -R www-data:www-data bootstrap/*
```

### Setup Pytho (Development)

#### A. Setup API Machine Learning (Python)

##### 1. Masuk ke Direktori Model
```bash
cd project/model/
```

##### 2. Buat dan Aktifkan Lingkungan Virtual
```bash
# Buat lingkungan virtual
python3 -m venv venv

# Aktifkan lingkungan virtual
source venv/bin/activate  # Linux/Mac
# atau
venv\Scripts\activate     # Windows
```

##### 3. Install Dependensi
```bash
pip install -r requirements.txt
```

##### 4. Latih Model (Opsional)
```bash
cd training_model
python3 train_model.py
cd ..
```

##### 5. Jalankan API Server
```bash
python3 api.py
```

#### B. Setup Aplikasi Web (Laravel Filament)

##### 1. Masuk ke Direktori Laravel
```bash
cd project/src
```

##### 2. Install Dependensi
```bash
# Install dependensi PHP
composer install
```

##### 3. Konfigurasi Environment
```bash
# Salin file contoh
cp .env.example .env

# Buat kunci aplikasi
php artisan key:generate
```

Buka file `.env` dan sesuaikan konfigurasi database (DB_HOST, DB_PORT, DB_DATABASE, DB_USERNAME, DB_PASSWORD).

##### 4. Setup Database
```bash
# Jalankan migrasi dan seeder
php artisan migrate:fresh --seed

# Buat user admin
php artisan make:filament-user
```

##### 5. Jalankan Server Laravel
```bash
php artisan serve
```

Server akan berjalan di http://127.0.0.1:8000.

## 🎮 Cara Menggunakan

1. Pastikan kedua server (Python API dan Laravel) sedang berjalan di terminalnya masing-masing.
2. Buka browser dan akses panel admin Anda: http://127.0.0.1:8000/admin
3. Login dengan akun admin yang telah Anda buat.
4. Navigasi ke menu "Students" di sidebar.
5. Klik tombol "Prediksi" (ikon ✨) pada salah satu baris siswa.
6. Konfirmasi action, dan Anda akan melihat notifikasi berisi hasil prediksi skor. Kolom "Prediksi Skor" di tabel juga akan ter-update.

## ⚠️ Troubleshooting Umum

### Koneksi Gagal / Timeout
Jika Laravel tidak bisa terhubung ke API Python:

- **Firewall**: Pastikan firewall di sistem operasi Anda tidak memblokir koneksi ke port 5000.
- **Docker/WSL**: Jika Anda menjalankan Laravel di dalam Docker/WSL, ganti alamat API di file `StudentsTable.php` dari `http://127.0.0.1:5000` menjadi `http://host.docker.internal:5000` (untuk Docker Desktop) atau alamat IP asli mesin host Anda.

### Error Permission Denied
```bash
chown -R www-data:www-data storage/*
chown -R www-data:www-data bootstrap/*
```

### Python Virtual Environment Issues
```bash
# Hapus environment lama
rm -rf venv

# Buat ulang
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## 📄 Lisensi

Proyek ini berada di bawah Lisensi MIT.