
import 'package:flutter/foundation.dart';
import '../models/favorite_book.dart';
import '../repositories/favorite_book_repository.dart';

class FavoriteBookProvider extends ChangeNotifier {
  final FavoriteBookRepository repository;

  FavoriteBookProvider({
    required this.repository,
  });

  List<FavoriteBook> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<FavoriteBook> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadFavorites() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _favorites = await repository.getFavoriteBooks();
    } catch (error, stackTrace) {
      debugPrint('ERROR LOAD FAVORITES: $error');
      debugPrint('$stackTrace');

      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addFavoriteBook({
    required String bookId,
    required String title,
    required String authors,
    required String note,
    required int rating,
  }) async {
    try {
      _errorMessage = null;

      await repository.addFavoriteBook(
        bookId: bookId,
        title: title,
        authors: authors,
        note: note,
        rating: rating,
      );

      await loadFavorites();

      if (_errorMessage != null) {
        return false;
      }

      return true;
    } catch (error, stackTrace) {
      debugPrint('ERROR ADD FAVORITE: $error');
      debugPrint('$stackTrace');

      _errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateFavoriteBook({
    required String id,
    required String note,
    required int rating,
  }) async {
    try {
      await repository.updateFavoriteBook(
        id: id,
        note: note,
        rating: rating,
      );

      await loadFavorites();

      return _errorMessage == null;
    } catch (error, stackTrace) {
      debugPrint('ERROR UPDATE FAVORITE: $error');
      debugPrint('$stackTrace');

      _errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteFavoriteBook(String id) async {
    try {
      await repository.deleteFavoriteBook(id);

      await loadFavorites();

      return _errorMessage == null;
    } catch (error, stackTrace) {
      debugPrint('ERROR DELETE FAVORITE: $error');
      debugPrint('$stackTrace');

      _errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }
}
