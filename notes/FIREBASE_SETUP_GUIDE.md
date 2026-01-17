# Panduan Membuat Project Firebase Baru (Step-by-Step)

Panduan ini akan membantu Anda membuat project Firebase dari nol, mengaktifkan fitur yang dibutuhkan (Auth, Firestore, Storage), dan menghubungkannya dengan aplikasi GiziSehat.

## Bagian 1: Membuat Project Baru

1.  Buka browser dan kunjungi [console.firebase.google.com](https://console.firebase.google.com/).
2.  Klik tombol **+ Add project** (atau "Create a project").
3.  **Nama Project**: Isi dengan nama yang diinginkan, misal `gizisehat-admin-v1`.
4.  **Google Analytics**: Boleh dimatikan (Uncheck) agar setup lebih cepat.
5.  Klik **Create Project**. Tunggu hingga selesai, lalu klik **Continue**.

## Bagian 2: Registrasi Aplikasi Android

1.  Di halaman utama project, klik ikon **Android** (robot hijau) di tengah layar.
2.  **Package Name**: Isi dengan `com.example.gizi_sehat_mobile_app`
    *   *Catatan*: Pastikan ini sesuai dengan `android/app/build.gradle` -> `applicationId`.
3.  **App Nickname**: `GiziSehat Admin` (Bebas).
4.  Klik **Register app**.
5.  **Download config file**: Klik tombol **Download google-services.json**.
    *   **PENTING**: Pindahkan file yang baru didownload ini ke folder: 
    *   `d:\Flutter-Gizi-Sehat\android\app\google-services.json`
    *   (Timpa/Replace file yang lama).
6.  Klik **Next** terus hingga selesai.

## Bagian 3: Mengaktifkan Authentication (Login)

1.  Di menu kiri, pilih **Build** > **Authentication**.
2.  Klik **Get started**.
3.  Pilih **Native Providers** > **Email/Password**.
4.  Aktifkan switch **Enable**.
5.  Klik **Save**.

## Bagian 4: Mengaktifkan Firestore Database (Database User)

1.  Di menu kiri, pilih **Build** > **Firestore Database**.
2.  Klik **Create database**.
3.  **Location**: Pilih `asia-southeast2` (Jakarta) atau `us-central1` (Default).
4.  **Rules**: Pilih **Start in test mode**.
5.  Klik **Enable**.

## Bagian 5: Mengaktifkan Storage (Untuk Upload Bukti Dokter)

Karena dokter harus upload bukti sertifikat/foto, kita butuh Storage.

1.  Di menu kiri, pilih **Build** > **Storage**.
2.  Klik **Get started**.
3.  **Rules**: Pilih **Start in test mode**.
4.  Klik **Next** -> **Done**.

---

## Bagian 6: Menyiapkan Admin (Data Awal)

Karena "Admin hanya 1", kita buat manual:

1.  Di aplikasi GiziSehat nanti, Register akun seperti biasa, misal `admin@gizi.com`.
2.  Setelah berhasil daftar, buka **Firestore Database** di Console.
3.  Masuk ke collection `users`.
4.  Cari dokumen dengan email `admin@gizi.com`.
5.  Ubah field `role` dari `parent` (atau apapun) menjadi `admin`.
6.  (Opsional) Ubah `status` menjadi `active`.

Sekarang Admin sudah siap untuk memverifikasi dokter lain.
