import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AlatPage extends StatefulWidget {
  const AlatPage({super.key});

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  final supabase = Supabase.instance.client;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar dengan warna cokelat abu-abu khas dashboard petugas
      appBar: AppBar(
        backgroundColor: const Color(0xFF756D6D),
        title: const Text(
          'Daftar Alat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          // Bagian Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF756D6D), // Warna background search bar
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Cari',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // Daftar Alat (Scrollable)
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase.from('alat').stream(primaryKey: ['alat_id']),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final alat = data[index];

                return _buildAlatCard(
                  alat['nama_alat'] ?? '-',
                  'Stok : ${alat['stok'] ?? 0}',
                  alat['status'] ?? '-',
                  alat['gambar'] ?? '',
               );
              },
            );
          },
        ),
      ),
      ],
      ),
    );
  }

  // Fungsi untuk membuat Card Alat
  Widget _buildAlatCard(String nama, String stok, String status, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5), // Background abu-abu muda sesuai gambar
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Gambar Alat dengan frame putih melingkar
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.all(8),
            child: imageUrl.startsWith('http')
              ? Image.network(imageUrl, fit: BoxFit.contain)
              : Image.asset(imageUrl, fit: BoxFit.contain),
            ),
          const SizedBox(width: 16),
          // Info Alat
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  stok,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6DAE70), // Warna hijau status
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 28, color: Colors.grey),
            onPressed: () {
              // nanti isi navigasi ke halaman ajukan peminjaman
           },
          ),
        ],
      ),
    );
  }
}