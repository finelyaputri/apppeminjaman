import 'package:flutter/material.dart';

class Pengembalian extends StatelessWidget {
  const Pengembalian({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Pengembalian'),
        automaticallyImplyLeading: true, // tombol back muncul
        backgroundColor: const Color(0xFF6E6E6E),
      ),
      body: const Center(
        child: Text(
          'Belum ada pengembalian',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
