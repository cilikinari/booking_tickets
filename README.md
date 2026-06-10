# Cinema+

## 1. Project Overview

Cinema+ adalah aplikasi pemesanan tiket bioskop berbasis mobile dan web yang dibangun menggunakan Flutter. Aplikasi ini menyajikan antarmuka pengguna yang interaktif untuk melihat daftar film yang sedang tayang, memilih jadwal dan lokasi bioskop, menentukan kursi secara spesifik, hingga proses checkout dan pembayaran.

Aplikasi ini terhubung langsung dengan backend Golang dan sudah mendukung fitur Real-Time WebSocket untuk memberikan notifikasi pembayaran sukses atau timeout secara instan.

## 2. Key Features

* Movie Catalog & Details: Menampilkan daftar film terbaru beserta deskripsi, genre, dan rating.
* Interactive Seat Selection: Memilih kursi bioskop secara visual.
* Real-Time Booking Timer: Countdown timer 5 menit untuk mengamankan kursi selama proses pembayaran.
* WebSocket Notifications: Menerima update status pembayaran secara real-time langsung dari server.
* Booking History: Melacak riwayat pemesanan tiket yang sukses maupun yang kedaluwarsa.

## 3. Tech Stack

* Framework: Flutter & Dart
* State Management: Provider (Multi-Provider Architecture)
* Networking: `http` (REST API) & `web_socket_channel` (WebSocket)

## 4. Getting Started (Installation Guide)

Sebelum menjalankan aplikasi ini, pastikan [Cinema+ Backend (Golang)] sudah berjalan di perangkat lokal atau server.

### Langkah-langkah Instalasi:

1. Clone repository ini ke perangkat lokal kamu.
2. Buka terminal di dalam folder project dan jalankan perintah berikut untuk mengunduh semua *dependencies*:

flutter pub get

### PENTING: Konfigurasi Koneksi API

Aplikasi ini melakukan request ke backend lokal. Jika menjalankan aplikasi ini di HP, wajib mengubah alamat IP pada file konfigurasi agar aplikasi tidak mengalami Connection Refused.

1. Buka file `lib/data/datasources/auth_services.dart` (atau tempat mendefinisikan `baseUrl`).
2. Ubah `baseUrl` menggunakan IPv4 laptop/WiFi:

static const String baseUrl = 'http://192.168.x.xx:3000/api/v1';
(Catatan: Jangan gunakan `localhost` jika melakukan *testing* di perangkat fisik).

### Menjalankan Aplikasi:

Jalankan aplikasi di emulator, web browser, atau perangkat fisik yang terhubung:

flutter run