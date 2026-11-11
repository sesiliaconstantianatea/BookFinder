
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:book_finder/services/google_books_service.dart';

void main() {
  group('GoogleBooksService', () {
    test('berhasil mengambil daftar buku dari API', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.queryParameters['q'], 'Harry Potter');
        expect(request.url.queryParameters['maxResults'], '20');

        return http.Response(
          jsonEncode({
            'items': [
              {
                'id': 'book-1',
                'volumeInfo': {
                  'title': 'Harry Potter',
                  'authors': ['J.K. Rowling'],
                  'categories': ['Fantasy'],
                  'description': 'Petualangan seorang penyihir',
                  'publishedDate': '1997',
                },
              },
            ],
          }),
          200,
        );
      });

      final service = GoogleBooksService(client: mockClient);
      final books = await service.searchBooks('Harry Potter');

      expect(books.length, 1);
      expect(books.first.title, 'Harry Potter');
      expect(books.first.authors.first, 'J.K. Rowling');

      mockClient.close();
    });

    test('mengembalikan daftar kosong jika tidak ada hasil', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'totalItems': 0}),
          200,
        );
      });

      final service = GoogleBooksService(client: mockClient);
      final books = await service.searchBooks('BukuTidakDitemukan');

      expect(books, isEmpty);

      mockClient.close();
    });

    test('menangani respons API dengan status gagal', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final service = GoogleBooksService(client: mockClient);

      expect(
        () => service.searchBooks('Harry Potter'),
        throwsException,
      );

      mockClient.close();
    });
  });
}
