import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 
import 'login.dart';
import '../pages/peminjam/home_peminjam.dart';
import '../pages/petugas/home_petugas.dart';
import '../pages/admin/home.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {


// ✅ PERBAIKAN — ambil user login
  final User? currentUser = Supabase.instance.client.auth.currentUser;

  // ✅ PERBAIKAN — variabel tampungan data DB
  String nama = "-";
  String role = "-";

  @override
  void initState() {
    super.initState();
    loadUserData(); // ✅ PERBAIKAN — load data saat halaman dibuka
  }

  // ✅ PERBAIKAN — ambil nama & role dari tabel berdasarkan email login
  Future<void> loadUserData() async {
    if (currentUser == null) return;

    final data = await Supabase.instance.client
        .from('users') // ⚠️ GANTI jika nama tabel kamu beda
        .select()
        .eq('email', currentUser!.email!)
        .single();

    setState(() {
      nama = data['nama'] ?? "-";
      role = data['role'] ?? "-";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      // ✅ PERBAIKAN: Gunakan SingleChildScrollView agar tidak overflow saat ada navbar
      body: SingleChildScrollView( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ===== HEADER =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              color: Colors.grey[600],
              child: const Text(
                "Profil",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ===== AVATAR =====
            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey[400],
                child: const Text(
                  "F",
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ===== FORM AREA =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Nama",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildField(nama),

                  const SizedBox(height: 18),

                  const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  _buildField(currentUser?.email ?? "-"),

                  const SizedBox(height: 18),

                  const Text(
                    "Role",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // ✅ PERBAIKAN — dari DB
                  _buildField(role),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ===== BUTTON AREA =====
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [

                  // BATAL
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        final r = role.toLowerCase();

                        if (r == 'admin') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomeDashboardAdmin()),
                          );

                        } else if (r == 'petugas') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePetugas()),
                          );

                        } else if (r == 'peminjam') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePeminjam()),
                          );

                        } else {
                          // fallback kalau role tidak terbaca
                          Navigator.pop(context);
                        }
                      },

                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Batal",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // LOGOUT
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // ✅ Perbaikan: Logout Supabase dan navigasi ke halaman Login
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Logout"),
                            content: const Text("Anda yakin ingin logout?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Batal"),
                               ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Logout"),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          await Supabase.instance.client.auth.signOut(); // ✅ Logout
                          // ✅ Navigasi ke halaman login, hapus semua route sebelumnya
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== FIELD STYLE =====
  static Widget _buildField(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
