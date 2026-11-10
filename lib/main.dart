
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/book.dart';
import 'providers/book_provider.dart';
import 'repositories/book_repository.dart';
import 'services/google_books_service.dart';

void main() {
  final googleBooksService = GoogleBooksService();

  final bookRepository = BookRepository(
    googleBooksService: googleBooksService,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => BookProvider(
        repository: bookRepository,
      ),
      child: const BookFinderApp(),
    ),
  );
}

class BookFinderApp extends StatelessWidget {
  const BookFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookFinder',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B4BDB),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F7FC),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = const [
    'Semua',
    'Fiksi',
    'Fantasi',
    'Romansa',
    'Misteri',
    'Pendidikan',
    'Teknologi',
    'Pengembangan Diri',
  ];

  final TextEditingController searchController =
      TextEditingController();

  String selectedCategory = 'Semua';

  final Map<String, String> categoryQueries = {
    'Fiksi': 'subject:fiction',
    'Fantasi': 'subject:fantasy',
    'Romansa': 'subject:romance',
    'Misteri': 'subject:mystery',
    'Pendidikan': 'subject:education',
    'Teknologi': 'subject:technology',
    'Pengembangan Diri': 'subject:self-help',
  };

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchBooks() {
    final query = searchController.text.trim();

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan judul atau nama penulis buku.'),
        ),
      );
      return;
    }

    setState(() {
      selectedCategory = 'Semua';
    });

    context.read<BookProvider>().searchBooks(query);
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });

    if (category == 'Semua') {
      searchController.clear();
      context.read<BookProvider>().searchBooks('');
      return;
    }

    final query = categoryQueries[category] ?? category;
    searchController.text = query;

    context.read<BookProvider>().searchBooks(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7FC),
        title: const Row(
          children: [
            Icon(
              Icons.menu_book_rounded,
              color: Color(0xFF5B4BDB),
              size: 30,
            ),
            SizedBox(width: 8),
            Text(
              'BookFinder',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF25213D),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Belum ada notifikasi baru.'),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1100,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Halo, Pecinta Buku! 👋',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF25213D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Temukan buku menarik untuk menemani harimu.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Kolom pencarian buku
                      TextField(
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => searchBooks(),
                        decoration: InputDecoration(
                          hintText: 'Cari judul atau penulis buku...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            onPressed: searchBooks,
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Judul kategori
                      const Text(
                        'Kategori Buku',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF25213D),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Daftar kategori
                      SizedBox(
                        height: 42,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected =
                                selectedCategory == category;

                            return ChoiceChip(
                              label: Text(category),
                              selected: isSelected,
                              selectedColor:
                                  const Color(0xFF5B4BDB),
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                color: isSelected
                                    ? const Color(0xFF5B4BDB)
                                    : Colors.black12,
                              ),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                              onSelected: (_) {
                                selectCategory(category);
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Hasil pencarian dari Google Books API
                      Consumer<BookProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40),
                                child: CircularProgressIndicator(
                                  color: Color(0xFF5B4BDB),
                                ),
                              ),
                            );
                          }

                          if (provider.errorMessage != null) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.error_outline_rounded,
                                      size: 48,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      provider.errorMessage!,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: searchBooks,
                                      child: const Text('Coba Lagi'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (provider.books.isEmpty) {
                            return const EmptyBookMessage();
                          }

                          return Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Hasil Pencarian',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF25213D),
                                    ),
                                  ),
                                  Text(
                                    '${provider.books.length} buku',
                                    style: const TextStyle(
                                      color: Color(0xFF5B4BDB),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Tampilan responsif
                              if (isWide)
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemCount: provider.books.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 130,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemBuilder: (context, index) {
                                    return BookCard(
                                      book: provider.books[index],
                                    );
                                  },
                                )
                              else
                                ...provider.books.map(
                                  (book) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12),
                                    child: BookCard(book: book),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Widget kartu buku
class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final category = book.category;

    final IconData bookIcon =
        category.toLowerCase().contains('fiction')
            ? Icons.auto_stories_rounded
            : category.toLowerCase().contains('fantasy')
                ? Icons.public_rounded
                : category.toLowerCase().contains('self')
                    ? Icons.lightbulb_outline_rounded
                    : Icons.menu_book_rounded;

    final Color bookColor =
        category.toLowerCase().contains('fiction')
            ? const Color(0xFFE8DDFB)
            : category.toLowerCase().contains('fantasy')
                ? const Color(0xFFDDEBF9)
                : const Color(0xFFE5E1F9);

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: book.thumbnail.isNotEmpty
                  ? Image.network(
                      book.thumbnail.replaceFirst(
                        'http://',
                        'https://',
                      ),
                      width: 64,
                      height: 82,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return BookCoverPlaceholder(
                          color: bookColor,
                          icon: bookIcon,
                        );
                      },
                    )
                  : BookCoverPlaceholder(
                      color: bookColor,
                      icon: bookIcon,
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25213D),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    book.authors.isNotEmpty
                        ? book.authors.join(', ')
                        : 'Penulis tidak diketahui',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EDFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF5B4BDB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}

// Tampilan pengganti jika gambar sampul tidak tersedia
class BookCoverPlaceholder extends StatelessWidget {
  final Color color;
  final IconData icon;

  const BookCoverPlaceholder({
    super.key,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 82,
      color: color,
      child: Icon(
        icon,
        size: 34,
        color: const Color(0xFF5B4BDB),
      ),
    );
  }
}

// Tampilan ketika belum ada hasil pencarian
class EmptyBookMessage extends StatelessWidget {
  const EmptyBookMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.auto_stories_rounded,
              size: 48,
              color: Colors.black38,
            ),
            SizedBox(height: 12),
            Text(
              'Selamat Datang di BookFinder!',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF25213D),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Cari judul atau nama penulis buku untuk '
              'menemukan koleksi buku menarik.',
              style: TextStyle(
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
