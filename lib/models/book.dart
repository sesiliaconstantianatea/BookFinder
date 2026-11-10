
class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String category;
  final String description;
  final String thumbnail;
  final String publishedDate;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.category,
    required this.description,
    required this.thumbnail,
    required this.publishedDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};

    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'Judul tidak tersedia',
      authors: List<String>.from(volumeInfo['authors'] ?? []),
      category: (volumeInfo['categories'] != null &&
              (volumeInfo['categories'] as List).isNotEmpty)
          ? volumeInfo['categories'][0]
          : 'Umum',
      description: volumeInfo['description'] ?? 'Tidak ada deskripsi',
      thumbnail:
          volumeInfo['imageLinks']?['thumbnail'] ?? '',
      publishedDate: volumeInfo['publishedDate'] ?? 'Tidak diketahui',
    );
  }
}
