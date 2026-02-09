import 'package:flutter/material.dart';
import 'create_kategori.dart';

void main() {
  runApp(const MaterialApp(
    home: ReadKategori(),
    debugShowCheckedModeBanner: false,
  ));
}

class ReadKategori extends StatelessWidget {
  const ReadKategori({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy kategori
    final List<String> kategoriList = ['Sepak Bola', 'Badminton', 'Voli'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Halaman Kategori',
          style: TextStyle(
            color: Colors.white, 
            fontSize: 18, 
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: const Color(0xFF756D6D), // Warna abu-abu header
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            height: 4.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Search Bar
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF756D6D),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white, size: 30),
                  hintText: 'Cari',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // List Kategori
            Expanded(
              child: ListView.builder(
                itemCount: kategoriList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      title: Text(
                        kategoriList[index],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.edit_note, color: Colors.grey.shade700, size: 30),
                            const SizedBox(width: 10),
                            Icon(Icons.delete, color: Colors.grey.shade700, size: 28),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Tombol Tambah Kategori
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateKategori()),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  label: const Text(
                    'Tambah Kategori',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E74D2), // Warna biru tombol
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
