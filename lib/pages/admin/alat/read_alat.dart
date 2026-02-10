import 'package:flutter/material.dart';
import '../../../models/alat_model.dart'; 
import '../../../services/alat_service.dart'; 
import 'create_alat.dart';
import 'delete_alat.dart';
import 'update_alat.dart'; 
import '../../admin/home.dart';
import '../read_user.dart';
import '../read_kategori.dart';
import '../../../auth/logout.dart';

class ReadAlatPage extends StatefulWidget {
  const ReadAlatPage({super.key});

  @override
  State<ReadAlatPage> createState() => _ReadAlatPageState();
}

class _ReadAlatPageState extends State<ReadAlatPage> {
  int _currentIndex = 1;
  final AlatService _alatService = AlatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF756D6D),
        automaticallyImplyLeading: false,
        title: const Text('Daftar Alat', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Pastikan nama class di create_alat.dart adalah CreateProdukPage
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateProdukPage()),
          );
          setState(() {}); 
        },
        backgroundColor: const Color(0xFF756D6D),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<List<Alat>>(
        future: _alatService.fetchAlat(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          
          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text("Belum ada data alat"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final a = list[i];
              return _buildAlatItem(a); // Kirim object utuh saja
            },
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Pisahkan BottomNav agar kode lebih bersih
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      selectedItemColor: Colors.grey[800],
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == _currentIndex) return;
        Widget page;
        switch (index) {
          case 0: page = const HomeDashboardAdmin(); break;
          case 2: page = const ReadUser(); break;
          case 3: page = const ReadKategori(); break;
          case 4: page = const LogoutPage(); break;
          default: return;
        }
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box_sharp), label: 'Alat'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'User'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Kategori'),
        BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
      ],
    );
  }

  Widget _buildAlatItem(Alat alat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E2E2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Gambar
          Container(
            width: 80, height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: alat.gambar.startsWith('http')
                ? Image.network(alat.gambar, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))
                : Image.asset(alat.gambar, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.inventory)),
          ),
          const SizedBox(width: 16),
          // Bagian Teks & Tombol
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alat.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Stok : ${alat.stok}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(alat.status, style: const TextStyle(color: Colors.green)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_note),
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateAlatPage(alat: alat)));
                            setState(() {});
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            DeleteAlat.showDeleteDialog(
                              context,
                              onConfirm: () async {
                                if (alat.id != null) {
                                  await _alatService.deleteAlat(alat.id!);
                                  setState(() {});
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}