import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class DeleteKategoriPage extends StatefulWidget {
  final String kategoriName; 
  final VoidCallback? onDeleted;

  const DeleteKategoriPage({super.key, required this.kategoriName, this.onDeleted});

  @override
  State<DeleteKategoriPage> createState() => _DeleteKategoriPageState();
}

class _DeleteKategoriPageState extends State<DeleteKategoriPage> {
  @override
  void initState() {
    super.initState();
    // Memunculkan dialog otomatis segera setelah halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDeleteConfirmation(context);
    });
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User wajib memilih tombol
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(color: Colors.grey, width: 0.5),
          ),
          title: Column(
            children: [
              const Text(
                'Hapus Kategori',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const Divider(thickness: 1),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              Text(
                'Apakah Anda yakin ingin menghapus kategori "${widget.kategoriName}"?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.only(bottom: 20, right: 20),
          actions: <Widget>[
            SizedBox(
              width: 70,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF756D6D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onPressed: () async {
                  final kategoriName = widget.kategoriName;

                // <-- Letakkan kode try-catch di sini
                try {
                  await Supabase.instance.client
                      .from('kategori')
                      .delete()
                      .eq('nama_kategori', kategoriName);

                  // Jika berhasil
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kategori "$kategoriName" berhasil dihapus')),
                  );

                  Navigator.of(context).pop(); // Tutup dialog
                  widget.onDeleted?.call(); // Reload halaman ReadKategori
                  Navigator.pop(context); // Kembali ke halaman ReadKategori
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Terjadi kesalahan: $e')),
                  );
                }
              },
                child: const Text(
                  'Iya',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 70,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                },
                child: const Text(
                  'Batal',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold dibuat kosong agar hanya fokus ke dialog
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF756F6F)),
      ),
    );
  }
}
