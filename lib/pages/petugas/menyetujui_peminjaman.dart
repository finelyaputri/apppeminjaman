import 'package:flutter/material.dart';

class MenyetujuiPeminjaman extends StatelessWidget {
  const MenyetujuiPeminjaman({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk tampilan
    final List<Map<String, String>> daftarPinjaman = [
      {'email': 'putri@gmail.com', 'item': 'Bola Sepak'},
      {'email': 'putri@gmail.com', 'item': 'Raket'},
      {'email': 'putri@gmail.com', 'item': 'Jersey Voli'},
      {'email': 'putri@gmail.com', 'item': 'Shuttlecock'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Peminjaman Masuk',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF756D6D),
        elevation: 0,
        // Tombol back otomatis muncul jika dinavigasi dari HomePetugas
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: daftarPinjaman.length,
        itemBuilder: (context, index) {
          return PeminjamanCard(
            email: daftarPinjaman[index]['email']!,
            itemName: daftarPinjaman[index]['item']!,
          );
        },
      ),
    );
  }
}

class PeminjamanCard extends StatelessWidget {
  final String email;
  final String itemName;

  const PeminjamanCard({
    super.key,
    required this.email,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            email,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.assignment_outlined,
                color: Color(0xFFF5A623),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                itemName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ActionButton(
                label: 'Tolak',
                color: const Color(0xFFD32F2F),
                onPressed: () {
                  // Tambahkan logika tolak di sini
                },
              ),
              const SizedBox(width: 12),
              _ActionButton(
                label: 'Setujui',
                color: const Color(0xFF6DAE70),
                onPressed: () {
                  // Tambahkan logika setujui di sini
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        // Solusi error minWidth: Menggunakan minimumSize
        minimumSize: const Size(90, 36), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}