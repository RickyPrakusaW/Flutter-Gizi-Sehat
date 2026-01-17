# Future Development Plan - GiziSehat

Dokumen ini menjelaskan roadmap pengembangan aplikasi GiziSehat dengan fokus utama pada **Pencegahan Stunting** melalui manajemen nutrisi cerdas, telemedisin, dan dukungan ekosistem.

---

## 🥗 1. Core: Smart Nutrition Management (Prioritas Utama)
Sesuai visi utama aplikasi untuk mengatur gizi anak stunting.

### **A. Jadwal Makan & Nutrisi (Nutrition Scheduler)**
- **Personalized Plan:** Sistem otomatis membuat jadwal makan (Pagi, Siang, Malam, Snack) berdasarkan usia, berat, dan status stunting anak.
- **Target Harian:** Visualisasi target kalori, protein, dan zat besi yang harus dipenuhi hari ini.
- **Reminder:** Notifikasi pengingat jam makan agar jadwal teratur (kunci perbaikan gizi).

### **B. AI Food Scanner (Deteksi Nutrisi)**
Fitur unggulan untuk memudahkan orang tua mengetahui kandungan gizi makanan.
- **Konsep:** Foto makanan di piring -> AI Menganalisa -> Keluar estimasi gizi.
- **Feedback Loop:**
  - AI akan memberitahu: "Makanan ini **kurang protein**, tambahkan 1 butir telur."
  - "Porsi ini sudah memenuhi 30% kebutuhan harian anak."

---

## 👨‍⚕️ 2. Telemedicine & Konsultasi (Doctor Role)
Eskalasi penanganan jika intervensi mandiri tidak berhasil.

### **Dokter / Ahli Gizi Role**
- **Dashboard Dokter:** Melihat grafik pertumbuhan pasien yang terhubung.
- **Chat Konsultasi:** Orang tua bisa chat langsung dengan dokter spesialis anak.
- **Resep Digital:** Dokter bisa memberikan "Resep Menu Makanan" yang langsung masuk ke Jadwal Makan orang tua.

---

## 🛒 3. Ekosistem Marketplace (Cart & Nota)
Mendukung pemenuhan gizi yang direkomendasikan.

- **Integrasi Rekomendasi:** Jika hasil deteksi stunting menunjukkan kekurangan zat besi, aplikasi langsung merekomendasikan suplemen/vitamin terkait di Marketplace.
- **Keranjang (Cart):** Pembelian multiple item.
- **Invoice:** Bukti transaksi digital.

---

## � 4. Multi-Role System
Pondasi untuk fitur Konsultasi dan Manajemen Wilayah.

- **Orang Tua:** Fokus ke anak sendiri.
- **Dokter:** Fokus ke pasien konsultasi.
- **Kader:** Fokus ke data satu wilayah (Posyandu).
- **Admin:** Manajemen sistem.

---

## � Roadmap Implementasi

### Phase 1: Foundation (Current Step)
- Multi-role System (User/Doctor).
- Basic Nutrition Schedule UI.
- Marketplace Basic (Cart/Nota).

### Phase 2: Intelligence
- Integrasi Google Gemini API untuk Food Detection.
- Algoritma rekomendasi menu otomatis.

### Phase 3: Telehealth
- Real-time Chat.
- Video Call (Opsional).
