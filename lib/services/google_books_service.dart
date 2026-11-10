
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class GoogleBooksService {
  static const String baseUrl =
      'https://www.googleapis.com/books/v1/volumes';

  static const String apiKey =
      String.fromEnvironment('GOOGLE_BOOKS_API_KEY');

  Future<List<Book>> searchBooks(String query) async {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'q': query,
        'maxResults': '20',
        if (apiKey.isNotEmpty) 'key': apiKey,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List items = data['items'] ?? [];

      return items
          .map((item) => Book.fromJson(item))
          .toList();
    } else {
      throw Exception(
        'Gagal mengambil data buku. Kode: ${response.statusCode}',
      );
    }
  }
}
