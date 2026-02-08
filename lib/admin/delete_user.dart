import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteUserPage extends StatefulWidget {
  final dynamic userId;

  const DeleteUserPage({super.key, this.userId});

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
      await supabase.from('users').delete().eq('id', widget.userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User berhasil dihapus')),
        );
        Navigator.pop(context); // Kembali ke ReadUser
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus user: $e')),
        );
        Navigator.pop(context); // Kembali jika gagal
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
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                child: const Text(
                  'Hapus User',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF616161),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Ikon Peringatan
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF756F6F), width: 3),
                ),
                child: const Icon(
                  Icons.priority_high,
                  size: 60,
                  color: Color(0xFF756F6F),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Apakah Anda yakin ingin menghapus user ini?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Color(0xFF756F6F)),
                ),
              ),
              const SizedBox(height: 30),
              // Tombol Aksi
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 80,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Tutup Dialog
                          _deleteUser(); // Jalankan fungsi hapus
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF756F6F),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Iya', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 80,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context); // Tutup Dialog
                          Navigator.pop(context); // Kembali ke ReadUser
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Batal', style: TextStyle(color: Color(0xFF756F6F))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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