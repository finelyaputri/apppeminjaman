import 'package:flutter/material.dart';
import '../../auth/logout.dart'; 
import 'alat.dart';

class HomePeminjam extends StatefulWidget {
  const HomePeminjam({super.key});

  @override
  State<HomePeminjam> createState() => _HomePeminjamState();
}

class _HomePeminjamState extends State<HomePeminjam> {
  int _currentIndex = 0;

  // DAFTAR HALAMAN
  // Halaman akan berganti sesuai index BottomNavigationBar
  final List<Widget> _pages = [
    const DashboardContent(), // Index 0: Tampilan kartu 'Lihat Alat'
    const Center(child: Text("Halaman Peminjaman")),
    const Center(child: Text("Halaman Pengembalian")),
    const LogoutPage(),     
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // --- APPBAR ---
      appBar: AppBar(
        title: const Text(
          'Dashboard Peminjam',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF756D6D),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      
      // --- BODY ---
      // Menampilkan halaman dari daftar _pages berdasarkan index aktif
      body: _pages[_currentIndex],

      // --- BOTTOM NAVBAR ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF756D6D),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        currentIndex: _currentIndex,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: (index) {
          // Mengubah index aktif sehingga body otomatis berganti
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.grid_view_rounded, size: 30),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.calendar_today_outlined, size: 30),
            ),
            label: 'Peminjaman',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.replay_rounded, size: 30),
            ),
            label: 'Pengembalian',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.logout_rounded, size: 30),
            ),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}

// --- KONTEN DASHBOARD (INDEX 0) ---
// Bagian ini dipisahkan agar kode utama tetap rapi dan mudah dibaca
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 100), // Memberi jarak dari atas sesuai gambar
          
          // Card Lihat Alat
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AlatPage()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lihat Alat',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}