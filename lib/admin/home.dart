import 'package:flutter/material.dart';
import 'package:app_peminjaman/auth/logout.dart';
import 'read_alat.dart';
import 'read_user.dart';

class HomeDashboardAdmin extends StatefulWidget {
  const HomeDashboardAdmin({super.key});

  @override
  State<HomeDashboardAdmin> createState() => _HomeDashboardAdminState();
}

class _HomeDashboardAdminState extends State<HomeDashboardAdmin> {
  int _currentIndex = 0;

  // ============================
  // 🔧 PERBAIKAN (HANYA INI)
  // ============================
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Berhasil login sebagai admin',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6E6E6E),
        elevation: 0,
        title: const Text(
          'Dashboard Admin',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CARD TOTAL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoCard('Total Alat', '20'),
                _infoCard('Total User', '20'),
                _infoCard('Total User', '20'),
              ],
            ),

            const SizedBox(height: 20),

            /// GRAFIK
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Peminjaman Per Minggu',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _bar(4, 'Sen'),
                        _bar(6, 'Sel'),
                        _bar(5, 'Rab'),
                        _bar(7, 'Kam'),
                        _bar(8, 'Jum'),
                        _bar(10, 'Sab'),
                        _bar(9, 'Min'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// MENU
            _menuButton('CRUD Data Peminjaman'),
            const SizedBox(height: 12),
            _menuButton('CRUD Pengembalian'),
            const SizedBox(height: 12),
            _menuButton('Log Aktivitas'),

            const SizedBox(height: 20),

            /// INFO CEPAT
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Info Cepat',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    Icons.warning_amber_rounded,
                    Colors.orange,
                    '3 alat rusak',
                  ),
                  const SizedBox(height: 8),
                  _infoRow(
                    Icons.assignment,
                    Colors.blue,
                    '4 Peminjaman Hari ini',
                  ),
                  const SizedBox(height: 8),
                  _infoRow(
                    Icons.assignment_turned_in,
                    Colors.green,
                    '1 Pengembalian hari ini',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.grey[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // ✅ Update index
          });

        
         if (index == 1) {
            // Navigasi ke halaman Alat
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReadAlatPage()),
            );
          }

          else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReadUser()),
            );
          }

    else if (index == 4) {
            // Logout
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LogoutPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_sharp),
            label: 'Alat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Kategori',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }

  /// ===== WIDGETS =====

  Widget _infoCard(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar(int value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 18,
          height: value * 10,
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  Widget _menuButton(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
