
import 'package:flutter_test/flutter_test.dart';
import 'package:book_finder/models/favorite_book.dart';
import 'package:book_finder/providers/favorite_book_provider.dart';
import 'package:book_finder/repositories/favorite_book_repository.dart';
import 'package:book_finder/services/favorite_books_service.dart';

class FakeFavoriteBookRepository implements FavoriteBookRepository {
  @override
  FavoriteBooksService get service => throw UnimplementedError();

  List<FavoriteBook> data = [];
  bool shouldThrowError = false;

  @override
  Future<List<FavoriteBook>> getFavoriteBooks() async {
    if (shouldThrowError) {
      throw Exception('Gagal memuat favorit');
    }
    return List.from(data);
  }

  @override
  Future<void> addFavoriteBook({
    required String bookId,
    required String title,
    required String authors,
    required String note,
    required int rating,
  }) async {
    if (shouldThrowError) {
      throw Exception('Gagal menambahkan favorit');
    }

    data.add(FavoriteBook(
      id: 'fav-${data.length + 1}',
      bookId: bookId,
      title: title,
      authors: authors,
      note: note,
      rating: rating,
    ));
  }

  @override
  Future<void> updateFavoriteBook({
    required String id,
    required String note,
    required int rating,
  }) async {
    if (shouldThrowError) {
      throw Exception('Gagal memperbarui favorit');
    }

    final index = data.indexWhere((book) => book.id == id);

    if (index != -1) {
      final oldBook = data[index];

      data[index] = FavoriteBook(
        id: oldBook.id,
        bookId: oldBook.bookId,
        title: oldBook.title,
        authors: oldBook.authors,
        note: note,
        rating: rating,
        createdAt: oldBook.createdAt,
      );
    }
  }

  @override
  Future<void> deleteFavoriteBook(String id) async {
    if (shouldThrowError) {
      throw Exception('Gagal menghapus favorit');
    }

    data.removeWhere((book) => book.id == id);
  }
}

void main() {
  late FakeFavoriteBookRepository fakeRepository;
  late FavoriteBookProvider provider;

  setUp(() {
    fakeRepository = FakeFavoriteBookRepository();
    provider = FavoriteBookProvider(repository: fakeRepository);
  });

  tearDown(() {
    provider.dispose();
  });

  group('FavoriteBookProvider', () {
    test('berhasil memuat daftar favorit', () async {
      fakeRepository.data = [
        FavoriteBook(
          id: 'fav-1',
          bookId: 'book-1',
          title: 'Harry Potter',
          authors: 'J.K. Rowling',
          note: 'Buku bagus',
          rating: 5,
        ),
      ];

      await provider.loadFavorites();

      expect(provider.favorites.length, 1);
      expect(provider.favorites.first.title, 'Harry Potter');
      expect(provider.isLoading, false);
      expect(provider.errorMessage, isNull);
    });

    test('berhasil menambahkan buku favorit', () async {
      final result = await provider.addFavoriteBook(
        bookId: 'book-2',
        title: 'The Hobbit',
        authors: 'J.R.R. Tolkien',
        note: 'Menarik',
        rating: 5,
      );

      expect(result, true);
      expect(provider.favorites.length, 1);
      expect(provider.favorites.first.title, 'The Hobbit');
    });

    test('berhasil memperbarui buku favorit', () async {
      fakeRepository.data = [
        FavoriteBook(
          id: 'fav-1',
          bookId: 'book-1',
          title: 'Harry Potter',
          authors: 'J.K. Rowling',
          note: 'Catatan lama',
          rating: 3,
        ),
      ];

      final result = await provider.updateFavoriteBook(
        id: 'fav-1',
        note: 'Catatan baru',
        rating: 5,
      );

      expect(result, true);
      expect(provider.favorites.first.note, 'Catatan baru');
      expect(provider.favorites.first.rating, 5);
    });

    test('berhasil menghapus buku favorit', () async {
      fakeRepository.data = [
        FavoriteBook(
          id: 'fav-1',
          bookId: 'book-1',
          title: 'Harry Potter',
          authors: 'J.K. Rowling',
          note: 'Favorit',
          rating: 5,
        ),
      ];

      final result = await provider.deleteFavoriteBook('fav-1');

      expect(result, true);
      expect(provider.favorites, isEmpty);
    });

    test('menangani kegagalan memuat favorit', () async {
      fakeRepository.shouldThrowError = true;

      await provider.loadFavorites();

      expect(provider.favorites, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.errorMessage, isNotNull);
    });

    test('menangani kegagalan menambahkan favorit', () async {
      fakeRepository.shouldThrowError = true;

      final result = await provider.addFavoriteBook(
        bookId: 'book-1',
        title: 'Harry Potter',
        authors: 'J.K. Rowling',
        note: 'Favorit',
        rating: 5,
      );

      expect(result, false);
      expect(provider.errorMessage, isNotNull);
    });
  });
}
