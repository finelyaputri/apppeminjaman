import 'package:flutter/material.dart';
import '../auth/logout.dart';

class HomePetugas extends StatefulWidget {
  const HomePetugas({super.key});

  @override
  State<HomePetugas> createState() => _HomePetugasState();
}

class _HomePetugasState extends State<HomePetugas> {
  @override
  void initState() {
    super.initState();

    // ✅ Menampilkan SnackBar "Berhasil login sebagai petugas"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil login sebagai petugas'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF756D6D),
        title: const Text(
          'Dashboard Petugas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Row untuk 3 Card Atas (Peminjaman Aktif, dkk)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Peminjaman\nAktif', '5', Icons.assignment_turned_in, Colors.green),
                _buildStatCard('Harus\nDikembalikan', '3', Icons.arrow_circle_left_outlined, Colors.orange),
                _buildStatCard('Terlambat', '1', Icons.warning_rounded, Colors.red),
              ],
            ),
            const SizedBox(height: 24),

            // Card Peminjaman Masuk
            _buildMainCard(
              title: 'Peminjaman Masuk',
              badgeCount: '4',
              child: Column(
                children: [
                  _buildListItem('putri@gmail.com', 'Bola Sepak'),
                  _buildListItem('putri@gmail.com', 'Raket'),
                  _buildListItem('putri@gmail.com', 'Jersey Voli'),
                  _buildListItem('putri@gmail.com', 'Shuttlecock'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Card Info Cepat
            _buildMainCard(
              title: 'Info Cepat',
              child: Column(
                children: [
                  _buildQuickInfoItem('3 alat rusak', Icons.warning_amber_rounded, Colors.orange),
                  _buildQuickInfoItem('4 Peminjaman Hari ini', Icons.shopping_bag_outlined, Colors.blue),
                  _buildQuickInfoItem('1 Pengembalian hari ini', Icons.published_with_changes, Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 80), // Padding bawah agar tidak tertutup nav
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Widget untuk 3 Card Statistik Kecil di Atas
  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(count, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Container Utama (Wrapper Putih dengan Shadow)
  Widget _buildMainCard({required String title, String? badgeCount, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                if (badgeCount != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Color(0xFFFDB851), shape: BoxShape.circle),
                    child: Text(badgeCount, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(12.0), child: child),
        ],
      ),
    );
  }

  // Item List untuk Peminjaman Masuk
  Widget _buildListItem(String email, String item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(email, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.assignment_outlined, size: 16, color: Colors.orangeAccent),
              const SizedBox(width: 4),
              Text(item, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }

  // Item List untuk Info Cepat
  Widget _buildQuickInfoItem(String text, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // Bottom Navigation Bar Custom
  Widget _buildBottomNav() {
    return Container(
      height: 70,
      color: const Color(0xFF756D6D),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.grid_view, 'Dashboard'),
          _buildNavItem(Icons.assignment_outlined, 'Peminjaman'),
          _buildNavItem(Icons.assignment_return_outlined, 'Pengembalian'),
          _buildNavItem(Icons.show_chart, 'Laporan'),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LogoutPage()),
              );
            },
            child: _buildNavItem(Icons.logout, 'Logout'),
          ),
          
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}