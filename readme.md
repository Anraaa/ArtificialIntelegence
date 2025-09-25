# Student Performance Predictor (Laravel, Flutter & Python API)

## 📖 Tentang Proyek

Student Performance Predictor adalah sebuah ekosistem aplikasi lengkap yang menunjukkan bagaimana mengintegrasikan sebuah model Machine Learning dengan dua jenis *frontend* yang berbeda: aplikasi web dan aplikasi mobile. Proyek ini terdiri dari tiga komponen utama:

1.  **Backend & Admin Panel (Laravel Filament)**: Sebuah panel admin berbasis web yang elegan dan fungsional. Digunakan untuk manajemen data siswa (CRUD) dan sebagai antarmuka untuk memicu prediksi skor dari web.

2.  **Aplikasi Mobile (Flutter)**: Aplikasi mobile cross-platform dengan UI/UX modern dan interaktif. Berfungsi sebagai antarmuka *end-user* untuk memasukkan data dan mendapatkan prediksi skor secara langsung di perangkat mereka.

3.  **API Machine Learning (Python Flask)**: Bertindak sebagai "otak" terpusat. API ini memuat model Machine Learning yang sudah dilatih dan melayani permintaan prediksi secara real-time dari kedua *frontend* (Laravel dan Flutter).

Proyek ini adalah contoh sempurna dari arsitektur *microservice* di mana antarmuka pengguna (web dan mobile) dan logika AI dipisahkan untuk skalabilitas dan kemudahan pengelolaan.

---

## ✨ Fitur Utama

#### Fitur Web (Laravel Filament)
-   **Manajemen Siswa**: Operasi CRUD (Create, Read, Update, Delete) penuh untuk data siswa.
-   **Prediksi Skor dari Web**: Tombol "Prediksi" di panel admin untuk memanggil API Python.
-   **Penyimpanan Hasil**: Hasil prediksi secara otomatis disimpan kembali ke database.

#### Fitur Mobile (Flutter)
-   **Prediksi Skor Interaktif**: Pengguna dapat mengubah parameter input dengan slider untuk melihat prediksi secara dinamis.
-   **UI/UX Modern & Responsif**: Tampilan yang bersih dan menarik, dibangun dengan Flutter.
-   **Tampilan Hasil Real-time**: Hasil prediksi ditampilkan secara instan di dalam aplikasi.

#### Fitur Arsitektur
-   **API Terpusat**: Satu *backend* AI yang melayani berbagai jenis *client*, memastikan konsistensi hasil prediksi.
-   **Pengembangan Terpisah**: Tim web, mobile, dan AI dapat bekerja secara independen.

---

## 🏛️ Arsitektur Sistem

Aplikasi ini menggunakan arsitektur *client-server* di mana Laravel Filament dan Flutter bertindak sebagai dua *client* berbeda yang mengirimkan permintaan HTTP ke server API Python yang sama.


<div align="center">
    <img src="hhttps://github.com/Anraaa/ArtificialIntelegence/blob/main/docs/img/arsitektur.png" alt="test">
</div>


---

## 🛠️ Teknologi yang Digunakan

| Komponen               | Teknologi                                               |
| ---------------------- | ------------------------------------------------------- |
| Backend & Admin Panel  | PHP 8.3, Laravel 11+, Filament 4                        |
| Aplikasi Mobile        | Dart, Flutter SDK, HTTP Package                         |
| API Machine Learning   | Python 3.9+, Flask, Scikit-learn, Pandas, Joblib, Numpy |
| Database               | MySQL (Digunakan oleh Laravel)                          |
| Lingkungan Development | Docker, Composer, Flutter SDK, Python venv              |

---

## 🚀 Panduan Instalasi dan Setup

Proses setup dibagi menjadi tiga bagian: API (wajib), Web (opsional), dan Mobile (opsional).

### Bagian 1: Setup API Machine Learning (Wajib)

Ini adalah *backend* yang harus berjalan agar aplikasi web dan mobile berfungsi.

1.  **Masuk ke Direktori Model**: `cd project/model/`
2.  **Buat & Aktifkan Lingkungan Virtual**:
    ```bash
    python3 -m venv venv
    source venv/bin/activate # Linux/Mac atau venv\Scripts\activate untuk Windows
    ```
3.  **Install Dependensi**: `pip install -r requirements.txt`
4.  **(Opsional) Latih Model**: `cd training_model && python3 train_model.py && cd ..`
5.  **Jalankan API Server**:
    ```bash
    python3 api.py
    ```
    Server akan berjalan di `http://127.0.0.1:5000`. **Biarkan terminal ini tetap terbuka.**

---

### Bagian 2: Setup Aplikasi Web (Laravel Filament)

#### Opsi A: Dengan Docker (Direkomendasikan)
1.  **Clone & Konfigurasi**:
    ```bash
    git clone <repo_url> && cd ArtificialIntelegence
    cd project/src
    cp .env.example .env
    ```
    Sesuaikan `.env` dengan konfigurasi di `docker-compose.yml`.
2.  **Build & Jalankan Container**:
    ```bash
    cd .. # Kembali ke folder ArtificialIntelegence/project
    docker compose up -d --build
    ```
3.  **Setup Aplikasi di Dalam Container**:
    ```bash
    docker exec -it ai bash
    composer install
    php artisan key:generate
    php artisan storage:link
    php artisan migrate --seed
    php artisan make:filament-user
    chown -R www-data:www-data storage bootstrap
    exit
    ```
    Aplikasi web sekarang berjalan.

#### Opsi B: Setup Lokal (Tanpa Docker)
1.  **Masuk ke Direktori & Install Dependensi**: `cd project/src && composer install`
2.  **Konfigurasi Environment**: `cp .env.example .env && php artisan key:generate`. Sesuaikan detail database di `.env`.
3.  **Setup Database**: `php artisan migrate:fresh --seed && php artisan make:filament-user`
4.  **Jalankan Server**: `php artisan serve`

---

### Bagian 3: Setup Aplikasi Mobile (Flutter)

1.  **Masuk ke Direktori Aplikasi**: `cd project/nama_folder_flutter_anda`
2.  **Install Dependensi**: `flutter pub get`
3.  **Konfigurasi Alamat API**: Buka `lib/services/api_service.dart` dan pastikan `_baseUrl` menunjuk ke alamat API yang benar (lihat bagian Troubleshooting).
4.  **Jalankan Aplikasi**: Pilih device di VS Code/Android Studio, lalu jalankan. Atau via terminal: `flutter run`

---

## 🎮 Cara Menggunakan

#### Menggunakan Versi Web
1.  Pastikan API Python dan server Laravel berjalan.
2.  Buka panel admin (misal: `http://localhost:8000/admin`).
3.  Login dan masuk ke menu "Students".
4.  Klik ikon ✨ "Prediksi" pada salah satu siswa. Hasil akan disimpan dan notifikasi akan muncul.

#### Menggunakan Versi Mobile
1.  Pastikan API Python berjalan.
2.  Jalankan aplikasi Flutter di emulator atau perangkat fisik.
3.  Gunakan slider untuk mengatur input, lalu tekan "Dapatkan Prediksi".
4.  Hasil akan langsung muncul di layar.

---

## ⚠️ Troubleshooting Umum

### Koneksi Gagal ke API Python
-   **Dari Laravel (Docker)**: Ganti alamat API di `StudentsTable.php` dari `http://127.0.0.1:5000` menjadi `http://host.docker.internal:5000`.
-   **Dari Flutter (Emulator Android)**: Ganti alamat API di `api_service.dart` menjadi `http://10.0.2.2:5000`.
-   **Dari Flutter (Perangkat Fisik)**: Pastikan HP dan laptop ada di jaringan WiFi yang sama, dan gunakan alamat IP lokal laptop Anda (misal: `http://192.168.1.10:5000`).
-   **Firewall**: Pastikan firewall tidak memblokir koneksi ke port `5000`.

### Masalah Izin Folder Laravel
Jika ada error *permission denied*, jalankan perintah ini di dalam direktori `project/src`:
```bash
sudo chown -R $USER:www-data storage bootstrap/cache
sudo chmod -R 775 storage bootstrap/cache
```

📄 Lisensi
Proyek ini berada di bawah Lisensi MIT.