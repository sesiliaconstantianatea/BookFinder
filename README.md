
# BookFinder

**Aplikasi Pencarian dan Pengelolaan Buku Berbasis Flutter**

BookFinder merupakan aplikasi mobile yang membantu pengguna mencari informasi buku melalui Google Books API serta menyimpan dan mengelola koleksi buku favorit menggunakan Supabase.

## Fitur Aplikasi

1. **Home / Dashboard** - Halaman utama aplikasi.
2. **Pencarian Buku** - Mencari buku melalui Google Books API.
3. **Kategori Buku** - Menyaring pencarian berdasarkan kategori.
4. **Detail Buku** - Menampilkan informasi judul, penulis, kategori, tanggal terbit, dan deskripsi.
5. **Tambah Favorit** - Menyimpan buku beserta catatan dan rating.
6. **Koleksi Favorit** - Menampilkan daftar buku favorit.
7. **Edit Favorit** - Mengubah catatan dan rating buku.
8. **Hapus Favorit** - Menghapus buku dari koleksi.
9. **About** - Menampilkan informasi aplikasi dan teknologi yang digunakan.

## Teknologi yang Digunakan

- Flutter dan Dart
- Provider dan ChangeNotifier
- Google Books API
- Supabase dan PostgreSQL
- HTTP
- Git dan GitHub

## Struktur Folder

```text
lib/
|-- models/
|-- providers/
|-- repositories/
|-- screens/
|-- services/
|-- widgets/
`-- main.dart

test/
|-- book_model_test.dart
|-- favorite_book_model_test.dart
|-- book_provider_test.dart
|-- favorite_book_provider_test.dart
`-- google_books_service_test.dart

docs/
`-- screenshots/
    |-- 01_home page.jpeg
    |-- 02_pencarian.jpeg
    |-- 03_detail buku.jpeg
    |-- 04_koleksi favorit.jpeg
    |-- 05_Tambah favorit.jpeg
    |-- 06_edit buku.jpeg
    `-- 07_tentang apk.jpeg
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
flutter run -d 8DKB9X458TX44TXW --dart-define=GOOGLE_BOOKS_API_KEY=AIzaSyD5RrZuQQOh3tVTgAoir4gdEMtrIkoWmAs --dart-define=SUPABASE_URL=https://pczxykwdqoiiqlopyvtk.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=sb_publishable_820AQI6A9puze1gh0wRAbQ_wD82B36Q
```

Ganti nilai contoh dengan konfigurasi milik sendiri.

## Database

BookFinder menggunakan tabel `favorite_books` pada Supabase dengan struktur berikut:

| Kolom | Tipe Data |
|---|---|
| id | UUID (Primary Key) |
| created_at | TIMESTAMPTZ |
| book_id | TEXT |
| title | TEXT |
| authors | TEXT |
| note | TEXT |
| rating | INT2 |

Database mendukung operasi Create, Read, Update, dan Delete (CRUD).

## State Management dan Arsitektur

Aplikasi menggunakan Provider dengan ChangeNotifier untuk mengelola state.

Struktur kode dipisahkan menjadi:

- **Models** - Representasi data aplikasi.
- **Services** - Komunikasi dengan API dan Supabase.
- **Repositories** - Penghubung service dengan provider.
- **Providers** - Pengelolaan state aplikasi.
- **Screens** - Halaman antarmuka aplikasi.
- **Widgets** - Komponen antarmuka yang dapat digunakan kembali.

## Pengujian

Pengujian otomatis dilakukan menggunakan Flutter Test.

**Total: 20 pengujian berhasil dijalankan.**

Cakupan pengujian meliputi:

- Parsing JSON model buku.
- Parsing JSON model buku favorit.
- Pengelolaan state BookProvider.
- Pengelolaan state FavoriteBookProvider.
- GoogleBooksService menggunakan HTTP MockClient.
- Penanganan hasil kosong dan respons API gagal.

Pemeriksaan kualitas kode dilakukan menggunakan:

```powershell
flutter analyze
flutter test
```

Hasil pemeriksaan terakhir: tidak ditemukan masalah kode dan seluruh 20 pengujian berhasil.

## Build APK

Untuk membuat APK release:

```powershell
flutter build apk --release --dart-define=GOOGLE_BOOKS_API_KEY=AIzaSyD5RrZuQQOh3tVTgAoir4gdEMtrIkoWmAs --dart-define=SUPABASE_URL=https://pczxykwdqoiiqlopyvtk.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=sb_publishable_820AQI6A9puze1gh0wRAbQ_wD82B36Q
```

Hasil APK berada di:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Dokumentasi Screenshot

Berikut dokumentasi tampilan aplikasi BookFinder pada perangkat Android.

### 1. Halaman Home / Dashboard

![Home Dashboard](docs/screenshots/01_home%20page.jpeg)

### 2. Halaman Pencarian Buku

![Pencarian Buku](docs/screenshots/02_pencarian.jpeg)

### 3. Halaman Detail Buku

![Detail Buku](docs/screenshots/03_detail%20buku.jpeg)

### 4. Halaman Koleksi Favorit

![Koleksi Favorit](docs/screenshots/04_koleksi%20favorit.jpeg)

### 5. Halaman Tambah Favorit

![Tambah Favorit](docs/screenshots/05_Tambah%20favorit.jpeg)

### 6. Halaman Edit Favorit

![Edit Favorit](docs/screenshots/06_edit%20buku.jpeg)

### 7. Halaman Tentang Aplikasi

![Tentang Aplikasi](docs/screenshots/07_tentang%20apk.jpeg)


## Dokumentasi Pengujian Manual

Pengujian dilakukan secara langsung pada perangkat Android Vivo Y20 untuk memastikan fitur aplikasi berjalan dengan baik.

| No. | Fitur yang Diuji | Hasil |
|---|---|---|
| 1 | Pencarian buku melalui Google Books API | Berhasil |
| 2 | Menampilkan detail buku | Berhasil |
| 3 | Menambahkan buku ke favorit | Berhasil |
| 4 | Menampilkan daftar buku favorit | Berhasil |
| 5 | Mengedit catatan dan rating buku | Berhasil |
| 6 | Menghapus buku favorit | Berhasil |
| 7 | Navigasi antarhalaman | Berhasil |
| 8 | Tampilan responsif pada perangkat Android | Berhasil |

Seluruh fitur utama berhasil diuji dan berjalan sesuai dengan fungsinya.

## Pengujian Otomatis

Pengujian otomatis dilakukan menggunakan Flutter Test dengan hasil:

- Total pengujian: 20 test
- Status: Seluruh test berhasil
- Perintah: `flutter test`

Pengujian mencakup:
1. Parsing JSON model Book.
2. Parsing JSON model FavoriteBook.
3. Pengelolaan state BookProvider.
4. Pengelolaan state FavoriteBookProvider.
5. GoogleBooksService, termasuk respons berhasil dan penanganan error API.

Hasil akhir: All tests passed!

## Analisis Kode

Pemeriksaan kualitas kode dilakukan menggunakan perintah:

`flutter analyze`

Hasil pemeriksaan:
- Status: Berhasil
- Temuan: No issues found!
- Tidak ditemukan masalah berdasarkan analisis statis Flutter.

## Repository

GitHub: https://github.com/sesiliaconstantianatea/BookFinder

---

**BookFinder - Aplikasi Pencarian dan Pengelolaan Buku**
