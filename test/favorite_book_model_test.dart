
import 'package:flutter_test/flutter_test.dart';
import 'package:book_finder/models/favorite_book.dart';

void main() {
  group('FavoriteBook.fromJson', () {
    test('berhasil membaca data favorit lengkap', () {
      final json = {
        'id': 'fav-001',
        'book_id': 'book-123',
        'title': 'Harry Potter',
        'authors': 'J.K. Rowling',
        'note': 'Buku favorit saya',
        'rating': 5,
        'created_at': '2026-11-11T10:00:00Z',
      };

      final book = FavoriteBook.fromJson(json);

      expect(book.id, 'fav-001');
      expect(book.bookId, 'book-123');
      expect(book.title, 'Harry Potter');
      expect(book.authors, 'J.K. Rowling');
      expect(book.note, 'Buku favorit saya');
      expect(book.rating, 5);
      expect(
        book.createdAt,
        DateTime.parse('2026-11-11T10:00:00Z'),
      );
    });

    test('menggunakan nilai default jika data tidak tersedia', () {
      final book = FavoriteBook.fromJson({});

      expect(book.id, '');
      expect(book.bookId, '');
      expect(book.title, 'Judul tidak tersedia');
      expect(book.authors, 'Penulis tidak diketahui');
      expect(book.note, '');
      expect(book.rating, 0);
      expect(book.createdAt, isNull);
    });

    test('mengubah rating numerik menjadi integer', () {
      final book = FavoriteBook.fromJson({
        'rating': 4.0,
      });

      expect(book.rating, 4);
    });

    test('menangani tanggal yang tidak valid', () {
      final book = FavoriteBook.fromJson({
        'created_at': 'tanggal-tidak-valid',
      });

      expect(book.createdAt, isNull);
    });
  });
}
