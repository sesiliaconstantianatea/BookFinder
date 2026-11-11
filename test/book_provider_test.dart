
import 'package:flutter_test/flutter_test.dart';
import 'package:book_finder/models/book.dart';
import 'package:book_finder/providers/book_provider.dart';
import 'package:book_finder/repositories/book_repository.dart';
import 'package:book_finder/services/google_books_service.dart';

class FakeBookRepository extends BookRepository {
  FakeBookRepository() : super(googleBooksService: GoogleBooksService());

  List<Book> result = [];
  bool shouldThrowError = false;
  String? lastQuery;

  @override
  Future<List<Book>> searchBooks(String query) async {
    lastQuery = query;

    if (shouldThrowError) {
      throw Exception('Simulasi kegagalan API');
    }

    return result;
  }
}

void main() {
  late FakeBookRepository fakeRepository;
  late BookProvider provider;

  setUp(() {
    fakeRepository = FakeBookRepository();
    provider = BookProvider(repository: fakeRepository);
  });

  tearDown(() {
    provider.dispose();
  });

  group('BookProvider', () {
    test('pencarian kosong mengosongkan daftar buku', () async {
      await provider.searchBooks('');

      expect(provider.books, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.errorMessage, isNull);
    });

    test('pencarian berhasil menampilkan daftar buku', () async {
      fakeRepository.result = [
        Book(
          id: 'book-001',
          title: 'Harry Potter',
          authors: ['J.K. Rowling'],
          category: 'Fantasy',
          description: 'Novel fantasi',
          thumbnail: '',
          publishedDate: '1997',
        ),
      ];

      await provider.searchBooks('Harry Potter');

      expect(fakeRepository.lastQuery, 'Harry Potter');
      expect(provider.books.length, 1);
      expect(provider.books.first.title, 'Harry Potter');
      expect(provider.isLoading, false);
      expect(provider.errorMessage, isNull);
    });

    test('kegagalan pencarian menampilkan pesan error', () async {
      fakeRepository.shouldThrowError = true;

      await provider.searchBooks('Harry Potter');

      expect(provider.books, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.errorMessage,
          'Gagal mengambil data buku. Periksa koneksi internet.');
    });
  });
}
