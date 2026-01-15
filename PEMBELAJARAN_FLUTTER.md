# Panduan Pembelajaran Flutter - GiziSehat Mobile App

Dokumen ini merupakan acuan wajib untuk pembelajaran dan pengembangan aplikasi GiziSehat. Materi disusun secara sistematis dari dasar hingga advanced.

---

## Daftar Materi Pembelajaran

### **1. Pengenalan & Persiapan Lingkungan Flutter**

- [ ] **Pengenalan dan Sintaks Dasar Flutter**
  - Memahami konsep dasar Flutter
  - Mempelajari sintaks Dart yang digunakan dalam Flutter
  - Hot reload dan hot restart

- [ ] **Kelebihan dan Kekurangan Flutter**
  - Cross-platform development
  - Performa dan kecepatan development
  - Limitation dan considerations

- [ ] **Pemahaman tentang Package**
  - Konsep package management
  - Cara menambahkan dependencies
  - Menggunakan pub.dev

- [ ] **Efficient Tooling**
  - Flutter CLI commands
  - IDE setup (VS Code / Android Studio)
  - Debugging tools

- [ ] **Instalasi Flutter & Android Studio**
  - Setup development environment
  - Konfigurasi Android SDK
  - Setup iOS (jika perlu)

- [ ] **Pembuatan Project Flutter pertama**
  - Membuat project baru
  - Struktur folder Flutter
  - Menjalankan aplikasi pertama

- [ ] **Pembuatan Layout dasar**
  - StatelessWidget dan StatefulWidget
  - Build method
  - Widget tree

---

### **2. Pemrograman Berorientasi Objek (OOP) dengan Dart**

- [ ] **Membuat Class**
  - Definisi class dan object
  - Constructor dan properties
  - Methods dalam class

- [ ] **Inheritance (Pewarisan)**
  - Extends keyword
  - Super keyword
  - Method overriding

- [ ] **Polymorphism (Polimorfisme)**
  - Interface implementation
  - Dynamic dispatch
  - Method overriding

- [ ] **Encapsulation (Enkapsulasi)**
  - Private members (underscore prefix)
  - Getter dan setter
  - Access modifiers

- [ ] **Abstraction (Abstraksi)**
  - Abstract classes
  - Abstract methods
  - Interface segregation

**Praktek:** Implementasi class untuk model data aplikasi GiziSehat (User, Child, GrowthData, dll)

---

### **3. Layouting & Komponen UI Dasar**

- [ ] **Appbar & Scaffold**
  - Struktur dasar aplikasi
  - AppBar properties
  - Scaffold body dan bottom navigation

- [ ] **SingleChildScrollView & SafeArea**
  - Handling overflow content
  - Safe area untuk berbagai device
  - Scrollable content

- [ ] **Row & Column (Pengaturan tata letak baris & kolom)**
  - MainAxis dan CrossAxis alignment
  - Flexible dan Expanded widgets
  - Spacing dan padding

- [ ] **Text & TextStyle**
  - Text widget properties
  - TextStyle customization
  - Text overflow handling

- [ ] **ElevatedButton & properti onPressed**
  - Button types (Elevated, Outlined, Text)
  - Event handling
  - Button styling

**Praktek:** Membuat UI dasar untuk screen onboarding, login, dan dashboard

---

### **4. Navigasi & Pengelolaan Data List (Studi Kasus: Todolist)**

- [ ] **Menyimpan Data dalam suatu Class**
  - Data modeling
  - Class untuk data structure
  - Data validation

- [ ] **Navigator & Pemindahan Halaman (Routing)**
  - Navigator.push dan Navigator.pop
  - Named routes
  - Passing data antar screen

- [ ] **Membuat ListView & Custom ListTile**
  - ListView.builder
  - ListTile customization
  - Separator widgets

- [ ] **Melakukan Reuse Widget (ToDoTile)**
  - Widget composition
  - Custom widget creation
  - Parameter passing ke widget

**Praktek:** Implementasi navigasi antar screen aplikasi GiziSehat dan list data

---

### **5. State Management Dasar (Provider)**

- [ ] **Menambahkan Dependencies Provider**
  - Menambahkan provider package
  - Update pubspec.yaml

- [ ] **Membuat Class Provider**
  - ChangeNotifier
  - State variables
  - Methods untuk update state

- [ ] **Inisialisasi Provider**
  - Provider setup di main.dart
  - MultiProvider untuk multiple providers
  - Provider scope

- [ ] **Menggunakan Provider pada UI**
  - Provider.of
  - Consumer widget
  - context.watch dan context.read

**Praktek:** Implementasi ThemeProvider dan AuthProvider untuk aplikasi GiziSehat

---

### **6. Koneksi ke API (HTTP)**

- [ ] **Menambahkan Dependencies HTTP Package**
  - http atau dio package
  - Konfigurasi dependencies

- [ ] **Menyiapkan Class untuk menerima respons (Model)**
  - JSON serialization
  - Model class creation
  - fromJson dan toJson methods

- [ ] **Membuat Method untuk memanggil API (Call API)**
  - GET, POST, PUT, DELETE requests
  - Error handling
  - Async/await pattern

- [ ] **Menampilkan respons API ke layar**
  - FutureBuilder
  - Loading states
  - Error states handling

**Praktek:** Integrasi API untuk data posyandu, artikel gizi, atau layanan kesehatan

---

### **7. Backend & Database Cloud (Firebase)**

- [ ] **Membuat & Setting Project Firebase**
  - Firebase Console setup
  - Project configuration
  - Billing setup (jika perlu)

- [ ] **Menambahkan Aplikasi Flutter ke Console Firebase**
  - Register Android app
  - Register iOS app
  - Download google-services.json / GoogleService-Info.plist

- [ ] **Menambahkan Dependencies Firebase**
  - firebase_core
  - firebase_auth
  - cloud_firestore
  - firebase_storage

- [ ] **Inisialisasi Firebase pada kodingan**
  - Firebase initialization
  - Platform configuration
  - Firebase options setup

- [ ] **Implementasi Firebase Authentication (Login/Register)**
  - Email/Password authentication
  - Google Sign-In
  - Apple Sign-In (iOS)
  - Auth state management

- [ ] **Implementasi Firebase Firestore (Database Realtime)**
  - Collection dan Document structure
  - CRUD operations
  - Real-time listeners
  - Query data

**Praktek:** Implementasi autentikasi dan penyimpanan data growth tracking ke Firestore

---

### **8. Database Lokal (SQLite)**

- [ ] **Membuat Class Model untuk Tabel Database**
  - Entity classes
  - Table structure
  - Field definitions

- [ ] **Membuat Class Helper untuk Mengakses SQLite**
  - Database helper class
  - Table creation
  - Database initialization

- [ ] **Memanggil Helper & Memasukkan Data (Insert)**
  - Insert operations
  - Update operations
  - Delete operations
  - Query operations

**Praktek:** Implementasi offline mode untuk data growth tracking menggunakan SQLite

---

### **9. Advanced State Management (BLoC)**

- [ ] **Menambahkan Dependencies BLoC**
  - flutter_bloc package
  - equatable package (optional)

- [ ] **Membuat Class Event & State**
  - Event classes
  - State classes
  - Immutable state pattern

- [ ] **Membuat Class BLoC**
  - BLoC class definition
  - Event-to-State mapping
  - Business logic implementation

- [ ] **Mengimplementasikan BLoC pada UI**
  - BlocProvider setup
  - BlocBuilder dan BlocListener
  - BlocConsumer usage

**Praktek:** Refactor AuthProvider ke AuthCubit/AuthBloc untuk autentikasi

---

### **10. Integrasi AI (Gemini)**

- [ ] **Mendapatkan API KEY**
  - Google AI Studio setup
  - API key generation
  - Security best practices

- [ ] **Membuat UI Aplikasi yang terintegrasi dengan AI**
  - Chat interface design
  - Message model
  - UI components untuk chat

- [ ] **Implementasi Chat dengan Gemini**
  - Google Generative AI SDK
  - Sending messages
  - Receiving responses
  - Stream handling

- [ ] **Optimasi dan Error Handling**
  - Loading states
  - Error messages
  - Rate limiting
  - Context management

**Praktek:** Implementasi AI Assistant untuk konsultasi gizi dan rekomendasi menu

---

## Checklist Progress Pembelajaran

### Minggu 1-2: Fundamental
- [ ] Materi 1: Pengenalan & Persiapan
- [ ] Materi 2: OOP dengan Dart
- [ ] Materi 3: Layouting & UI Dasar

### Minggu 3-4: Intermediate
- [ ] Materi 4: Navigasi & List Management
- [ ] Materi 5: State Management (Provider)
- [ ] Materi 6: Koneksi API

### Minggu 5-6: Backend Integration
- [ ] Materi 7: Firebase (Auth & Firestore)
- [ ] Materi 8: Database Lokal (SQLite)

### Minggu 7-8: Advanced
- [ ] Materi 9: BLoC Pattern
- [ ] Materi 10: Integrasi AI (Gemini)

---

## Catatan Implementasi untuk GiziSehat

### Fitur yang harus diimplementasi berdasarkan materi:

1. **Onboarding & Auth** (Materi 3, 4, 7)
   - Onboarding screen dengan PageView
   - Login/Register dengan Firebase Auth
   - Google Sign-In integration

2. **Dashboard** (Materi 3, 5)
   - Home screen dengan Provider
   - Growth summary cards
   - Navigation bar

3. **Growth Tracking** (Materi 7, 8)
   - Input form untuk BB/TB/LLA
   - Chart visualization (WHO growth chart)
   - Firestore untuk cloud sync
   - SQLite untuk offline mode

4. **Menu & Gizi** (Materi 6)
   - API integration untuk resep
   - List menu sehat
   - Kalkulator gizi

5. **AI Assistant** (Materi 10)
   - Chat interface
   - Gemini integration
   - Context-aware responses

6. **Health Locator** (Materi 6)
   - Google Maps integration
   - Location services
   - Nearby healthcare facilities

7. **Profile** (Materi 5, 7)
   - User profile management
   - Dark mode toggle (Provider)
   - Settings screen

---

## Target Setelah Menyelesaikan Semua Materi

Setelah menyelesaikan semua 10 materi pembelajaran, Anda harus mampu:

✅ Membuat aplikasi Flutter dengan struktur yang clean dan terorganisir  
✅ Mengimplementasikan state management yang sesuai (Provider/BLoC)  
✅ Mengintegrasikan Firebase untuk autentikasi dan database  
✅ Membuat fitur offline dengan SQLite  
✅ Mengintegrasikan AI (Gemini) untuk fitur konsultasi  
✅ Menangani API calls dan error handling dengan baik  
✅ Membuat UI yang responsive dan user-friendly  
✅ Mengimplementasikan navigasi yang kompleks  
✅ Menulis kode yang mengikuti best practices OOP  

---

## Sumber Referensi

- [Flutter Official Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Firebase Flutter Documentation](https://firebase.flutter.dev/)
- [BLoC Pattern Documentation](https://bloclibrary.dev/)
- [Google Generative AI (Gemini)](https://ai.google.dev/docs)
- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart/introduction)

---

**Status Pembelajaran:** 🔄 **On Progress**

**Terakhir diupdate:** `date +%Y-%m-%d`

---

*Dokumen ini adalah acuan wajib untuk pembelajaran dan pengembangan aplikasi GiziSehat. Setiap materi harus dipahami dan dipraktekkan sebelum melanjutkan ke materi berikutnya.*
