# BookFinder

**Aplikasi Pencarian dan Pengelolaan Buku Berbasis Flutter**

BookFinder adalah aplikasi mobile yang membantu pengguna mencari informasi buku melalui Google Books API serta menyimpan dan mengelola daftar buku favorit menggunakan Supabase.

## Fitur Aplikasi

1. **Home / Dashboard** — Halaman utama aplikasi.
2. **Pencarian Buku** — Mencari buku melalui Google Books API.
3. **Kategori Buku** — Menyaring pencarian berdasarkan kategori.
4. **Detail Buku** — Menampilkan informasi buku, penulis, kategori, tanggal terbit, dan deskripsi.
5. **Tambah Favorit** — Menyimpan buku ke daftar favorit beserta catatan dan rating.
6. **Koleksi Favorit** — Menampilkan buku-buku yang telah disimpan.
7. **Edit Favorit** — Mengubah catatan dan rating buku.
8. **Hapus Favorit** — Menghapus buku dari koleksi.
9. **About** — Menampilkan informasi aplikasi dan teknologi yang digunakan.

## Teknologi yang Digunakan

- Flutter
- Dart
- Provider dan ChangeNotifier
- Google Books API
- Supabase
- PostgreSQL
- HTTP
- Git dan GitHub

## Struktur Folder

```text
lib/
├── models/
├── providers/
├── repositories/
├── screens/
├── services/
├── widgets/
└── main.dart
```

## Konfigurasi dan Instalasi

### 1. Persiapan

Pastikan Flutter SDK dan Android SDK sudah terpasang.

### 2. Clone Repository

```bash
git clone https://github.com/sesiliaconstantianatea/BookFinder.git
cd BookFinder
```

### 3. Instal Dependencies

```bash
flutter pub get
```

### 4. Konfigurasi API dan Supabase

Siapkan Google Books API Key serta URL dan Publishable Key dari proyek Supabase milik sendiri.

Jangan mengunggah kunci API atau konfigurasi rahasia ke repository publik.

### 5. Jalankan Aplikasi

Contoh perintah melalui PowerShell:

```powershell
flutter run --dart-define=GOOGLE_BOOKS_API_KEY=ISI_API_KEY --dart-define=SUPABASE_URL=ISI_URL_SUPABASE --dart-define=SUPABASE_PUBLISHABLE_KEY=ISI_PUBLISHABLE_KEY
```

Ganti nilai contoh tersebut dengan konfigurasi milik sendiri.

## Database

BookFinder menggunakan tabel `favorite_books` pada Supabase dengan kolom:

| Kolom | Tipe Data |
|---|---|
| id | UUID (Primary Key) |
| created_at | TIMESTAMPTZ |
| book_id | TEXT |
| title | TEXT |
| authors | TEXT |
| note | TEXT |
| rating | INT2 |

Operasi database meliputi Create, Read, Update, dan Delete (CRUD).

## State Management dan Arsitektur

Aplikasi menggunakan Provider dengan ChangeNotifier untuk mengelola state.

Pemisahan kode dilakukan melalui model, service, repository, provider, screen, dan reusable widget agar struktur aplikasi lebih terorganisasi.

## Pengujian

Pengujian yang dilakukan meliputi:

- Pencarian buku.
- Menampilkan detail buku.
- Menambahkan buku ke favorit.
- Mengubah catatan dan rating.
- Menghapus buku favorit.
- Memeriksa tampilan pada perangkat Android.

## Build APK

Untuk membuat APK release:

```powershell
flutter build apk --release --dart-define=GOOGLE_BOOKS_API_KEY=ISI_API_KEY --dart-define=SUPABASE_URL=ISI_URL_SUPABASE --dart-define=SUPABASE_PUBLISHABLE_KEY=ISI_PUBLISHABLE_KEY
```

Hasil APK berada di:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Repository

GitHub: https://github.com/sesiliaconstantianatea/BookFinder

---

**BookFinder — Aplikasi Pencarian dan Pengelolaan Buku**