# Task List - GiziSehat Mobile App
## Berdasarkan Proposal Multi-Platform Mobile Programming

> **Project:** GiziSehat Mobile App - Solusi Digital Pencegahan Stunting  
> **Timeline:** 8 Minggu  
> **Tech Stack:** Flutter 3.x, Supabase, Material 3

---

## 📋 Daftar Isi
1. [Milestones & Acceptance Criteria](#milestones--acceptance-criteria)
2. [Feature Breakdown (MVP)](#feature-breakdown-mvp)
3. [Project Plan & Timeline](#project-plan--timeline)
4. [Deliverables](#deliverables)
5. [Quality Plan](#quality-plan)
6. [Dependencies & Setup](#dependencies--setup)

---

## 🎯 Milestones & Acceptance Criteria

### M1: Struktur Proyek & Autentikasi
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Setup struktur folder proyek Flutter
- [ ] Konfigurasi Supabase project
- [ ] Setup authentication (Email, Google, Apple)
- [ ] Implementasi halaman Login
- [ ] Implementasi halaman Register
- [ ] Implementasi Reset Password
- [ ] Testing autentikasi (login/register berfungsi)
- [ ] Dokumentasi setup autentikasi

**Acceptance Criteria:**
- ✅ Login/Register berfungsi dengan Email
- ✅ Login dengan Google berfungsi
- ✅ Reset password berfungsi
- ✅ User dapat logout

---

### M2: Growth Tracking
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Implementasi halaman Growth Tracking
- [ ] Form input BB (Berat Badan)
- [ ] Form input TB (Tinggi Badan)
- [ ] Form input LLA (Lingkar Lengan Atas)
- [ ] Validasi input data (range check)
- [ ] Integrasi perhitungan Z-score WHO
- [ ] Implementasi grafik WHO (weight-for-age, height-for-age)
- [ ] Deteksi risiko stunting
- [ ] Export data ke PDF
- [ ] Mode offline dengan SQLite (Drift)
- [ ] Sinkronisasi data dengan Supabase
- [ ] Testing input data & grafik

**Acceptance Criteria:**
- ✅ Input data pertumbuhan berfungsi
- ✅ Grafik WHO tampil dengan benar
- ✅ Deteksi risiko stunting akurat
- ✅ Data tersimpan offline & online

---

### M3: Menu & AI Assistant
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Implementasi halaman Menu & Gizi
- [ ] Rencana menu sehat harian
- [ ] Kalkulator gizi (kalori, protein, dll)
- [ ] Saran resep anak berdasarkan usia
- [ ] Progress bar target gizi harian
- [ ] Jadwal makan harian
- [ ] Implementasi AI Assistant (chat interface)
- [ ] Integrasi AI untuk konsultasi gizi
- [ ] Rekomendasi menu personal dari AI
- [ ] Cache jawaban AI untuk performa
- [ ] Testing kalkulator gizi
- [ ] Testing AI Assistant

**Acceptance Criteria:**
- ✅ Kalkulator gizi berfungsi
- ✅ Chat AI aktif dan responsif
- ✅ Rekomendasi menu sesuai kebutuhan
- ✅ Target gizi harian terhitung dengan benar

---

### M4: Health Locator & Profile
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Implementasi halaman Health Locator
- [ ] Integrasi Google Maps API
- [ ] Tampilkan lokasi Posyandu terdekat
- [ ] Tampilkan lokasi Puskesmas terdekat
- [ ] Tampilkan lokasi Rumah Sakit terdekat
- [ ] Kontak darurat kesehatan
- [ ] Implementasi halaman Profil
- [ ] Form data orang tua
- [ ] Form data anak (multi-child support)
- [ ] Dark mode toggle
- [ ] Pengaturan notifikasi
- [ ] Pengaturan bahasa (Bahasa Indonesia)
- [ ] Testing navigasi lengkap
- [ ] Testing mode gelap

**Acceptance Criteria:**
- ✅ Navigasi lengkap berfungsi
- ✅ Mode gelap aktif
- ✅ Health locator menampilkan lokasi terdekat
- ✅ Profil user dapat diupdate

---

### M5: Demo & Dokumentasi
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Final testing semua fitur
- [ ] Debugging & bug fixing
- [ ] Performance optimization
- [ ] Dokumentasi arsitektur aplikasi
- [ ] User guide (panduan penggunaan)
- [ ] Test plan & hasil uji
- [ ] README proyek (struktur folder, cara run, build)
- [ ] Laporan hasil uji
- [ ] Rekomendasi pengembangan selanjutnya
- [ ] Demo aplikasi
- [ ] Video demo (opsional)

**Acceptance Criteria:**
- ✅ App stabil dan tidak crash
- ✅ Dokumentasi lengkap
- ✅ Laporan siap diserahkan
- ✅ Demo berjalan dengan baik

---

## 🚀 Feature Breakdown (MVP)

### 1. Onboarding Flow (3 Slide)
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Design 3 slide onboarding
- [ ] Slide 1: Edukasi misi aplikasi
- [ ] Slide 2: Fitur utama aplikasi
- [ ] Slide 3: CTA "Mulai Sekarang"
- [ ] Implementasi PageView untuk onboarding
- [ ] Skip button
- [ ] Indicator dots
- [ ] Simpan status onboarding (first time user)
- [ ] Testing onboarding flow

---

### 2. Autentikasi Pengguna
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Setup Supabase Auth
- [ ] Halaman Login (Email)
- [ ] Halaman Register (Email)
- [ ] Login dengan Google
- [ ] Login dengan Apple (iOS)
- [ ] Reset Password
- [ ] Email verification
- [ ] Error handling autentikasi
- [ ] Loading states
- [ ] Testing semua metode login

---

### 3. Beranda (Dashboard)
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Design dashboard layout
- [ ] AI Assistant Card (promosi)
- [ ] Ringkasan pertumbuhan anak
- [ ] Tips gizi harian
- [ ] List anak-anak yang terdaftar
- [ ] Quick actions (4 card shortcut)
- [ ] Navigation ke tab lain
- [ ] Refresh data
- [ ] Testing dashboard

---

### 4. Tumbuh (Growth Tracking)
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Halaman Growth Tracking
- [ ] Form input pengukuran (BB/TB/LLA)
- [ ] Validasi input (range check)
- [ ] Perhitungan Z-score WHO
- [ ] Grafik pertumbuhan (weight-for-age)
- [ ] Grafik pertumbuhan (height-for-age)
- [ ] Deteksi risiko stunting
- [ ] Status gizi (Normal, Berisiko, dll)
- [ ] Export PDF laporan
- [ ] Riwayat pengukuran
- [ ] Mode offline (SQLite)
- [ ] Sinkronisasi dengan Supabase
- [ ] Testing growth tracking

---

### 5. Menu & Gizi
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Halaman Menu & Gizi
- [ ] Rencana menu sehat harian
- [ ] Kalkulator gizi (kalori, protein, zat besi, seng)
- [ ] Progress bar target gizi
- [ ] Jadwal makan harian
- [ ] Saran resep berdasarkan usia
- [ ] Rekomendasi menu dari AI
- [ ] Tambah makanan ke jadwal
- [ ] Foto makanan (opsional)
- [ ] Testing menu & gizi

---

### 6. Asisten AI
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Halaman AI Assistant (chat interface)
- [ ] Integrasi AI service (Gemini/OpenAI)
- [ ] Chat history
- [ ] Quick questions
- [ ] Context-aware responses
- [ ] Rekomendasi menu personal
- [ ] Konsultasi gizi
- [ ] Cache jawaban untuk performa
- [ ] Error handling
- [ ] Loading states
- [ ] Testing AI Assistant

---

### 7. Profil Pengguna
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Halaman Profil
- [ ] Form data orang tua
- [ ] Form data anak (multi-child)
- [ ] Tambah anak baru
- [ ] Edit profil anak
- [ ] Hapus anak
- [ ] Dark mode toggle
- [ ] Pengaturan notifikasi
- [ ] Pengaturan bahasa
- [ ] Logout
- [ ] Hapus akun
- [ ] Ekspor data
- [ ] Testing profil

---

### 8. Layanan Kesehatan
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Halaman Health Locator
- [ ] Setup Google Maps API
- [ ] Integrasi Google Maps
- [ ] Lokasi user (GPS)
- [ ] Tampilkan Posyandu terdekat
- [ ] Tampilkan Puskesmas terdekat
- [ ] Tampilkan Rumah Sakit terdekat
- [ ] Detail lokasi (nama, alamat, kontak)
- [ ] Navigasi ke lokasi (Google Maps)
- [ ] Kontak darurat kesehatan
- [ ] Testing health locator

---

## 📅 Project Plan & Timeline

### Week 1: Persiapan & Wireframe
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Review proposal & requirements
- [ ] Setup Figma mockup final
- [ ] Design system (colors, typography, components)
- [ ] Wireframe semua halaman
- [ ] Setup struktur folder proyek Flutter
- [ ] Setup Git repository
- [ ] Setup Supabase project
- [ ] Konfigurasi environment variables
- [ ] Setup CI/CD (GitHub Actions)

---

### Week 2-3: Autentikasi & Onboarding
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Implementasi Onboarding (3 slide)
- [ ] Halaman Login
- [ ] Halaman Register
- [ ] Integrasi Supabase Auth
- [ ] Login dengan Google
- [ ] Login dengan Apple (iOS)
- [ ] Reset Password
- [ ] Email verification
- [ ] Testing autentikasi
- [ ] Dokumentasi autentikasi

---

### Week 4: Dashboard & Navigasi
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Setup bottom navigation bar
- [ ] Implementasi Home Screen (Dashboard)
- [ ] AI Assistant Card
- [ ] Ringkasan pertumbuhan
- [ ] Tips gizi harian
- [ ] List anak-anak
- [ ] Quick actions
- [ ] Navigation flow
- [ ] Testing navigasi

---

### Week 5: Growth Tracking
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Halaman Growth Tracking
- [ ] Form input pengukuran
- [ ] Validasi input
- [ ] Perhitungan Z-score WHO
- [ ] Grafik WHO (library chart)
- [ ] Deteksi risiko
- [ ] Export PDF
- [ ] Mode offline (SQLite)
- [ ] Sinkronisasi data
- [ ] Testing growth tracking

---

### Week 6: Menu Gizi & Kalkulator
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Halaman Menu & Gizi
- [ ] Rencana menu harian
- [ ] Kalkulator gizi
- [ ] Progress bar target
- [ ] Jadwal makan
- [ ] Saran resep
- [ ] Integrasi AI untuk rekomendasi
- [ ] Testing menu & kalkulator

---

### Week 7: Health Locator & Profile
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Setup Google Maps API
- [ ] Halaman Health Locator
- [ ] Integrasi Google Maps
- [ ] Lokasi terdekat (Posyandu, Puskesmas, RS)
- [ ] Kontak darurat
- [ ] Halaman Profil
- [ ] Form data user & anak
- [ ] Dark mode
- [ ] Pengaturan
- [ ] Testing health locator & profile

---

### Week 8: Testing & Release
**Status:** ⏳ In Progress / ✅ Completed / ❌ Not Started

#### Tasks:
- [ ] Final testing semua fitur
- [ ] Bug fixing
- [ ] Performance optimization
- [ ] Unit tests
- [ ] Widget tests
- [ ] Integration tests
- [ ] Manual QA (3 devices)
- [ ] Dokumentasi lengkap
- [ ] README proyek
- [ ] User guide
- [ ] Test plan & hasil
- [ ] Demo aplikasi
- [ ] Laporan final

---

## 📦 Deliverables

### Aplikasi
- [ ] Aplikasi Flutter versi 1.0 (Android)
- [ ] Aplikasi Flutter versi 1.0 (iOS)
- [ ] APK untuk testing
- [ ] IPA untuk testing (jika ada Mac)

### Database
- [ ] Database schema Supabase
- [ ] Migration scripts
- [ ] Seed data (jika diperlukan)

### Dokumentasi
- [ ] Dokumentasi arsitektur aplikasi
- [ ] User guide (panduan penggunaan)
- [ ] Test plan & hasil uji
- [ ] README proyek
- [ ] Laporan hasil uji
- [ ] Rekomendasi pengembangan selanjutnya

### Design Assets
- [ ] Figma mockup final
- [ ] Design system documentation
- [ ] Icon assets
- [ ] Image assets

---

## ✅ Quality Plan

### Testing
- [ ] Unit Test: Validasi input, logika z-score
- [ ] Widget Test: Form pengukuran & tampilan grafik
- [ ] Integration Test: Alur onboarding & login
- [ ] Manual QA: 3 device (low, mid, high-end Android)

### Static Checks
- [ ] `flutter analyze` - no errors
- [ ] `dart fix --apply` - applied
- [ ] Lint: `very_good_analysis` - passed

### Performance Gates
- [ ] Cold start < 2s
- [ ] Crash-free ≥ 99%
- [ ] Ukuran bundle Android < 30 MB

---

## 🔧 Dependencies & Setup

### Required Setup
- [ ] Flutter SDK 3.x installed
- [ ] Supabase Project created
- [ ] Google Maps API key obtained
- [ ] Figma Design Assets accessed
- [ ] Firebase Messaging setup (jika diperlukan)
- [ ] GitHub Actions CI configured

### Environment Variables
- [ ] Supabase URL
- [ ] Supabase Anon Key
- [ ] Google Maps API Key
- [ ] AI API Key (jika diperlukan)

---

## 📊 Success Metrics

### Tracking
- [ ] ≥ 70% pengguna aktif mencatat data pertumbuhan minimal sekali seminggu
- [ ] ≥ 80% pengguna membaca konten edukasi gizi setiap bulan
- [ ] ≥ 90% tingkat keberhasilan input data tanpa error

### Analytics
- [ ] Setup analytics (fitur yang paling sering digunakan)
- [ ] Track engagement artikel
- [ ] Monitor crash reports

---

## 🚨 Risks & Mitigations

### Risk Management
- [ ] Koneksi internet lemah → Mode offline + sinkronisasi otomatis
- [ ] Error input data → Validasi & range check
- [ ] Overload AI Assistant → Cache jawaban & edge function
- [ ] Ketidaksesuaian UI antar device → Responsive layout + golden tests

---

## 📝 Notes

### Completed Features
- ✅ Halaman Growth Tracking (basic)
- ✅ Halaman Menu & Gizi (basic)
- ✅ Halaman Dashboard (basic)
- ✅ Halaman Assistant (basic, tanpa AI)
- ✅ Halaman Profile (basic)
- ✅ Bottom Navigation
- ✅ Dark Mode support
- ✅ Onboarding screen

### In Progress
- ⏳ Integrasi Supabase
- ⏳ Grafik WHO
- ⏳ AI Assistant integration
- ⏳ Health Locator

### Not Started
- ❌ Export PDF
- ❌ Google Maps integration
- ❌ Multi-child support
- ❌ Offline mode (SQLite)

---

## 📚 Referensi

- Proposal MMP: `notes/PROPOSAL_MMP.pdf`
- Figma Design: https://www.figma.com/make/yWZBjOpGYr6C1V7LnHu9v2/GiziSehat-Mobile-App
- WHO SDG Target 2.2: https://www.who.int/data/gho/data/themes/topics/indicator-groups/indicator-group-details/GHO/sdg-target-2.2-child-malnutrition

---

**Last Updated:** $(date)  
**Status:** In Progress
