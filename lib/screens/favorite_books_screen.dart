
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/favorite_book.dart';
import '../providers/favorite_book_provider.dart';
import 'edit_favorite_screen.dart';

class FavoriteBooksScreen extends StatefulWidget {
  const FavoriteBooksScreen({super.key});

  @override
  State<FavoriteBooksScreen> createState() =>
      _FavoriteBooksScreenState();
}

class _FavoriteBooksScreenState
    extends State<FavoriteBooksScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FavoriteBookProvider>().loadFavorites();
    });
  }

  Future<void> _refreshFavorites() async {
    await context.read<FavoriteBookProvider>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Koleksi Favorit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<FavoriteBookProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.favorites.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null &&
              provider.favorites.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _refreshFavorites,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.favorites.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshFavorites,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 140),
                  Icon(
                    Icons.menu_book_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Belum Ada Buku Favorit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Tambahkan buku ke koleksi favoritmu.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshFavorites,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                final book = provider.favorites[index];

                return FavoriteBookCard(book: book);
              },
            ),
          );
        },
      ),
    );
  }
}

class FavoriteBookCard extends StatelessWidget {
  final FavoriteBook book;

  const FavoriteBookCard({
    super.key,
    required this.book,
  });

  Future<void> _editFavorite(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFavoriteScreen(
          favorite: book,
        ),
      ),
    );
  }

  Future<void> _deleteFavorite(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Buku?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus "${book.title}" dari koleksi favorit?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true || !context.mounted) return;

    final provider = context.read<FavoriteBookProvider>();

    final success = await provider.deleteFavoriteBook(book.id);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Buku berhasil dihapus dari favorit!'
              : 'Gagal menghapus buku: ${provider.errorMessage ?? "Terjadi kesalahan"}',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 55,
              height: 75,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.menu_book,
                size: 35,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    book.authors,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text('${book.rating}/5'),
                    ],
                  ),
                  if (book.note.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Catatan: ${book.note}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Edit buku',
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () => _editFavorite(context),
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.deepPurple,
                    size: 22,
                  ),
                ),
                IconButton(
                  tooltip: 'Hapus buku',
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () => _deleteFavorite(context),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
