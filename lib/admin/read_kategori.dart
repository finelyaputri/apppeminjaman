import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'create_kategori.dart';

import 'home.dart';
import 'read_alat.dart';
import 'read_user.dart';
import '../auth/logout.dart';
import 'update_kategori.dart';
import 'delete_kategori.dart';


void main() {
  runApp(const MaterialApp(
    home: ReadKategori(),
    debugShowCheckedModeBanner: false,
  ));
}

class ReadKategori extends StatefulWidget {
  const ReadKategori({super.key});

  @override
  State<ReadKategori> createState() => _ReadKategoriState();
}

class _ReadKategoriState extends State<ReadKategori> {
  List<Map<String, dynamic>> kategoriList = [];


  /// ✅ PERBAIKAN — LOAD DATA SUPABASE
  Future<void> loadKategori() async {
    final data = await Supabase.instance.client
        .from('kategori')
        .select()
        .order('nama_kategori');

    setState(() {
      kategoriList = List<Map<String, dynamic>>.from(data);
    });
  }

  @override
  void initState() {
    super.initState();
    loadKategori();
  }


  @override
  Widget build(BuildContext context) {
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
        automaticallyImplyLeading: false,
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
                        kategoriList[index]['nama_kategori'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit_note, color: Colors.grey.shade700, size: 30),
                              onPressed: () async {
                                final dataKategori = kategoriList[index];

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateKategori(
                                      kategori: dataKategori,
                                    ),
                                  ),
                               );

                                loadKategori();
                              },
                            ),

                            const SizedBox(width: 10),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.grey.shade700, size: 28),
                              onPressed: () async {
                                final kategoriName = kategoriList[index]['nama_kategori'];

                              // Navigasi ke halaman DeleteKategoriPage
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeleteKategoriPage(
                                    kategoriName: kategoriName,
                                    onDeleted: () {
                                  // Callback untuk reload list setelah kategori dihapus
                                      loadKategori();
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
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
                  onPressed: () async {
                    final hasil = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateKategori()),
                    );

                    /// ✅ TAMBAH DATA KE LIST SAAT KEMBALI
                    if (hasil != null) {
                      loadKategori(); // ✅ PERBAIKAN — reload dari supabase
                    }
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

      /// ✅ NAVBAR BARU
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3, // Index 3 untuk Kategori
        selectedItemColor: Colors.grey[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeDashboardAdmin()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ReadAlatPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ReadUser()));
          } else if (index == 4) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LogoutPage()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_sharp), label: 'Alat'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'User'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Kategori'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
      ),
    );
  }
}
