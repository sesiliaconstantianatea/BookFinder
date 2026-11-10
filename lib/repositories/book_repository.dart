
import '../models/book.dart';
import '../services/google_books_service.dart';

class BookRepository {
  final GoogleBooksService googleBooksService;

  BookRepository({
    required this.googleBooksService,
  });

  Future<List<Book>> searchBooks(String query) {
    return googleBooksService.searchBooks(query);
  }
}
