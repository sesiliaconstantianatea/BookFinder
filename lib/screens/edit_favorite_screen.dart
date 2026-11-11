
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/favorite_book.dart';
import '../providers/favorite_book_provider.dart';

class EditFavoriteScreen extends StatefulWidget {
  final FavoriteBook favorite;

  const EditFavoriteScreen({
    super.key,
    required this.favorite,
  });

  @override
  State<EditFavoriteScreen> createState() =>
      _EditFavoriteScreenState();
}

class _EditFavoriteScreenState
    extends State<EditFavoriteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _noteController;

  late int _rating;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _noteController = TextEditingController(
      text: widget.favorite.note,
    );

    _rating = widget.favorite.rating;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _updateFavorite() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final success =
        await context.read<FavoriteBookProvider>()
            .updateFavoriteBook(
      id: widget.favorite.id,
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
          content: Text('Buku favorit berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } else {
      final error = context
          .read<FavoriteBookProvider>()
          .errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal memperbarui buku: ${error ?? "Terjadi kesalahan"}',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 8),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorite = widget.favorite;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Buku Favorit'),
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
                    const Icon(
                      Icons.menu_book,
                      size: 90,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      favorite.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(favorite.authors),
                  ],
                ),
              ),
              const SizedBox(height: 30),
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
                  border: OutlineInputBorder(),
                  hintText: 'Tulis catatan pribadi...',
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
                initialValue: _rating >= 1 && _rating <= 5
                    ? _rating
                    : 5,
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
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      _isSaving ? null : _updateFavorite,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _isSaving
                        ? 'Menyimpan perubahan...'
                        : 'Simpan Perubahan',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
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
