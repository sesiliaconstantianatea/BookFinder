
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/favorite_book_provider.dart';

class AddFavoriteScreen extends StatefulWidget {
  final Book book;

  const AddFavoriteScreen({
    super.key,
    required this.book,
  });

  @override
  State<AddFavoriteScreen> createState() => _AddFavoriteScreenState();
}

class _AddFavoriteScreenState extends State<AddFavoriteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  int _rating = 5;
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveFavorite() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final provider = context.read<FavoriteBookProvider>();

      final success = await provider.addFavoriteBook(
        bookId: widget.book.id,
        title: widget.book.title,
        authors: widget.book.authors.join(', '),
        note: _noteController.text.trim(),
        rating: _rating,
      );

      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku berhasil ditambahkan ke favorit!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } else {
        final errorMessage = provider.errorMessage ??
            'Penyebab kesalahan tidak diketahui.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menyimpan: $errorMessage',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 10),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Buku Favorit'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    if (book.thumbnail.isNotEmpty)
                      Image.network(
                        book.thumbnail.replaceFirst(
                          'http://',
                          'https://',
                        ),
                        height: 180,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.menu_book,
                            size: 100,
                            color: Colors.deepPurple,
                          );
                        },
                      )
                    else
                      const Icon(
                        Icons.menu_book,
                        size: 100,
                        color: Colors.deepPurple,
                      ),
                    const SizedBox(height: 12),
                    Text(
                      book.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      book.authors.isEmpty
                          ? 'Penulis tidak diketahui'
                          : book.authors.join(', '),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Catatan Pribadi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Mengapa kamu menyukai buku ini?',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Catatan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Rating Buku',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _rating,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star),
                ),
                items: List.generate(
                  5,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1} / 5 Bintang'),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _rating = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveFavorite,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.favorite),
                  label: Text(
                    _isSaving ? 'Menyimpan...' : 'Simpan ke Favorit',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
