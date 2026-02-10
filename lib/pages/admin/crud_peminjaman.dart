import 'package:flutter/material.dart';

class CrudPeminjamanPage extends StatelessWidget {
  const CrudPeminjamanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Peminjaman'),
        automaticallyImplyLeading: true, // tombol back muncul
        backgroundColor: const Color(0xFF6E6E6E),
      ),
      body: const Center(
        child: Text(
          'Belum ada peminjaman',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
