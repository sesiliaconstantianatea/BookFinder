
import '../models/favorite_book.dart';
import '../services/favorite_books_service.dart';

class FavoriteBookRepository {
  final FavoriteBooksService service;

  FavoriteBookRepository({
    required this.service,
  });

  Future<List<FavoriteBook>> getFavoriteBooks() async {
    final data = await service.getFavoriteBooks();

    return data
        .map((item) => FavoriteBook.fromJson(item))
        .toList();
  }

  Future<void> addFavoriteBook({
    required String bookId,
    required String title,
    required String authors,
    required String note,
    required int rating,
  }) {
    return service.addFavoriteBook(
      bookId: bookId,
      title: title,
      authors: authors,
      note: note,
      rating: rating,
    );
  }

  Future<void> updateFavoriteBook({
    required String id,
    required String note,
    required int rating,
  }) {
    return service.updateFavoriteBook(
      id: id,
      note: note,
      rating: rating,
    );
  }

  Future<void> deleteFavoriteBook(String id) {
    return service.deleteFavoriteBook(id);
  }
}
