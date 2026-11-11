
class FavoriteBook {
  final String id;
  final String bookId;
  final String title;
  final String authors;
  final String note;
  final int rating;
  final DateTime? createdAt;

  FavoriteBook({
    required this.id,
    required this.bookId,
    required this.title,
    required this.authors,
    required this.note,
    required this.rating,
    this.createdAt,
  });

  factory FavoriteBook.fromJson(Map<String, dynamic> json) {
    return FavoriteBook(
      id: json['id'] ?? '',
      bookId: json['book_id'] ?? '',
      title: json['title'] ?? 'Judul tidak tersedia',
      authors: json['authors'] ?? 'Penulis tidak diketahui',
      note: json['note'] ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
