
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteBooksService {
  final SupabaseClient _client = Supabase.instance.client;

  // Mengambil semua buku favorit
  Future<List<Map<String, dynamic>>> getFavoriteBooks() async {
    final response = await _client
        .from('favorite_books')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // Menambahkan buku favorit
  Future<void> addFavoriteBook({
    required String bookId,
    required String title,
    required String authors,
    required String note,
    required int rating,
  }) async {
    await _client.from('favorite_books').insert({
      'book_id': bookId,
      'title': title,
      'authors': authors,
      'note': note,
      'rating': rating,
    });
  }

  // Mengubah data buku favorit
  Future<void> updateFavoriteBook({
    required String id,
    required String note,
    required int rating,
  }) async {
    await _client.from('favorite_books').update({
      'note': note,
      'rating': rating,
    }).eq('id', id);
  }

  // Menghapus buku favorit
  Future<void> deleteFavoriteBook(String id) async {
    await _client
        .from('favorite_books')
        .delete()
        .eq('id', id);
  }
}
