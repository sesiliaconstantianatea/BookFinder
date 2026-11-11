
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/book.dart';
import 'providers/book_provider.dart';
import 'providers/favorite_book_provider.dart';
import 'repositories/book_repository.dart';
import 'repositories/favorite_book_repository.dart';
import 'services/google_books_service.dart';
import 'services/favorite_books_service.dart';
import 'screens/add_favorite_screen.dart';
import 'screens/favorite_books_screen.dart';
import 'screens/about_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    publishableKey: const String.fromEnvironment(
      'SUPABASE_PUBLISHABLE_KEY',
    ),
  );

  final googleBooksService = GoogleBooksService();

  final bookRepository = BookRepository(
    googleBooksService: googleBooksService,
  );

  final favoriteBooksService = FavoriteBooksService();

  final favoriteBookRepository = FavoriteBookRepository(
    service: favoriteBooksService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BookProvider(
            repository: bookRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteBookProvider(
            repository: favoriteBookRepository,
          ),
        ),
      ],
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

// =====================================================
// HALAMAN HOME
// =====================================================

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

  // Menggabungkan kata kunci dan kategori.
  // Teks pencarian tidak diganti dengan subject kategori.
  String buildSearchQuery() {
    final keyword = searchController.text.trim();
    final categoryQuery = categoryQueries[selectedCategory];

    if (keyword.isEmpty) {
      return categoryQuery ?? 'books';
    }

    if (categoryQuery == null) {
      return keyword;
    }

    return '$keyword $categoryQuery';
  }

  // Melakukan pencarian dengan kategori yang sedang aktif.
  void searchBooks() {
    final keyword = searchController.text.trim();

    if (keyword.isEmpty && selectedCategory == 'Semua') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Masukkan judul atau nama penulis buku.',
          ),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    context.read<BookProvider>().searchBooks(
          buildSearchQuery(),
        );
  }

  // Mengubah kategori tanpa menghapus kata kunci pencarian.
  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });

    context.read<BookProvider>().searchBooks(
          buildSearchQuery(),
        );
  }

  void openBookDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailScreen(book: book),
      ),
    );
  }

  void openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoriteBooksScreen(),
      ),
    );
  }

  void openAbout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutScreen(),
      ),
    );
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
            tooltip: 'Koleksi Favorit',
            onPressed: openFavorites,
            icon: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFF5B4BDB),
            ),
          ),
          IconButton(
            tooltip: 'Tentang Aplikasi',
            onPressed: openAbout,
            icon: const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFF5B4BDB),
            ),
          ),
          IconButton(
            tooltip: 'Notifikasi',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Belum ada notifikasi baru.'),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1100,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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

                      // KOLOM PENCARIAN
                      TextField(
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => searchBooks(),
                        decoration: InputDecoration(
                          hintText:
                              'Cari judul atau penulis buku...',
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
                            borderRadius:
                                BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // KATEGORI BUKU
                      const Text(
                        'Kategori Buku',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF25213D),
                        ),
                      ),
                      const SizedBox(height: 14),

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

                      // HASIL PENCARIAN
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
                                      onPressed: () {
                                        context
                                            .read<BookProvider>()
                                            .searchBooks(
                                              buildSearchQuery(),
                                            );
                                      },
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
                                      onTap: () => openBookDetail(
                                        provider.books[index],
                                      ),
                                    );
                                  },
                                )
                              else
                                ...provider.books.map(
                                  (book) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12,
                                    ),
                                    child: BookCard(
                                      book: book,
                                      onTap: () =>
                                          openBookDetail(book),
                                    ),
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

// =====================================================
// KARTU BUKU
// =====================================================

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
                        errorBuilder:
                            (context, error, stackTrace) {
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
      ),
    );
  }
}

// =====================================================
// HALAMAN DETAIL BUKU
// =====================================================

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({
    super.key,
    required this.book,
  });

  Future<void> _openAddFavorite(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddFavoriteScreen(book: book),
      ),
    );

    if (!context.mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Buku berhasil disimpan ke koleksi favorit.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authors = book.authors.isNotEmpty
        ? book.authors.join(', ')
        : 'Penulis tidak diketahui';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7FC),
        title: const Text(
          'Detail Buku',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF25213D),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Hero(
                    tag: 'book-${book.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: book.thumbnail.isNotEmpty
                          ? Image.network(
                              book.thumbnail.replaceFirst(
                                'http://',
                                'https://',
                              ),
                              width: 180,
                              height: 250,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return const BookDetailCoverPlaceholder();
                              },
                            )
                          : const BookDetailCoverPlaceholder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    book.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25213D),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    authors,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _DetailInfoChip(
                        icon: Icons.category_rounded,
                        label: book.category,
                      ),
                      _DetailInfoChip(
                        icon: Icons.calendar_month_rounded,
                        label: book.publishedDate,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.black12,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.menu_book_rounded,
                              color: Color(0xFF5B4BDB),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Deskripsi Buku',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF25213D),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          book.description.isNotEmpty
                              ? book.description
                              : 'Deskripsi buku belum tersedia.',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.7,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () => _openAddFavorite(context),
                      icon: const Icon(Icons.favorite),
                      label: const Text(
                        'Simpan ke Favorit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF5B4BDB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text(
                        'Kembali ke Katalog',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF5B4BDB),
                        side: const BorderSide(
                          color: Color(0xFF5B4BDB),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// WIDGET INFORMASI DETAIL
// =====================================================

class _DetailInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailInfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EDFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF5B4BDB),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF5B4BDB),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// WIDGET SAMPUL DETAIL
// =====================================================

class BookDetailCoverPlaceholder extends StatelessWidget {
  const BookDetailCoverPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 250,
      color: const Color(0xFFE5E1F9),
      child: const Icon(
        Icons.menu_book_rounded,
        size: 80,
        color: Color(0xFF5B4BDB),
      ),
    );
  }
}

// =====================================================
// WIDGET PENDUKUNG
// =====================================================

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
