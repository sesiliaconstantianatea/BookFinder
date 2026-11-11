
import 'package:flutter_test/flutter_test.dart';
import 'package:book_finder/models/book.dart';

void main() {
  group('Book.fromJson', () {
    test('berhasil membaca data buku lengkap', () {
      final json = {
        'id': 'book123',
        'volumeInfo': {
          'title': 'Harry Potter',
          'authors': ['J.K. Rowling'],
          'categories': ['Fantasy'],
          'description': 'A fantasy novel',
          'imageLinks': {
            'thumbnail': 'https://example.com/book.jpg',
          },
          'publishedDate': '1997',
        },
      };

      final book = Book.fromJson(json);

      expect(book.id, 'book123');
      expect(book.title, 'Harry Potter');
      expect(book.authors, ['J.K. Rowling']);
      expect(book.category, 'Fantasy');
      expect(book.description, 'A fantasy novel');
      expect(book.thumbnail, 'https://example.com/book.jpg');
      expect(book.publishedDate, '1997');
    });

    test('menggunakan nilai default jika data tidak tersedia', () {
      final book = Book.fromJson({
        'id': 'book456',
        'volumeInfo': {},
      });

      expect(book.id, 'book456');
      expect(book.title, 'Judul tidak tersedia');
      expect(book.authors, isEmpty);
      expect(book.category, 'Umum');
      expect(book.description, 'Tidak ada deskripsi');
      expect(book.thumbnail, isEmpty);
      expect(book.publishedDate, 'Tidak diketahui');
    });

    test('menggunakan kategori Umum jika kategori kosong', () {
      final book = Book.fromJson({
        'id': 'book789',
        'volumeInfo': {
          'title': 'Buku Tanpa Kategori',
          'categories': [],
        },
      });

      expect(book.category, 'Umum');
    });
  });
}
