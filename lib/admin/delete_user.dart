import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteUserPage extends StatefulWidget {
  final String userId; 
  final VoidCallback? onDeleted;

 const DeleteUserPage({super.key, required this.userId, this.onDeleted});

  @override
  State<DeleteUserPage> createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    // Memunculkan dialog otomatis segera setelah halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDeleteConfirmation(context);
    });
  }

  // Fungsi Logika Hapus ke Supabase
  Future<void> _deleteUser() async {
  try {
    await supabase.from('users').delete().eq('user_id', widget.userId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User berhasil dihapus')),
      );
      widget.onDeleted?.call(); // <-- panggil callback untuk refresh list
      Navigator.pop(context); // Tutup DeleteUserPage
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus user: $e')),
      );
      Navigator.pop(context); // Tutup halaman jika gagal
    }
  }
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
                'Hapus User',
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
              const Text(
                'Apakah Anda yakin ingin menghapus user ini?',
                textAlign: TextAlign.center,
                style: TextStyle(
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
                  Navigator.of(context).pop(); // Tutup dialog terlebih dahulu
                  await _deleteUser(); // Jalankan fungsi hapus
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
                  Navigator.of(context).pop(); // Hanya tutup dialog tanpa aksi
                  Navigator.pop(context); // Kembali ke ReadUser
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
