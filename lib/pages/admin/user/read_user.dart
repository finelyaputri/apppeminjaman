import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'create_user.dart';
import 'update_user.dart';
import 'delete_user.dart';

import '../home.dart';
import '../alat/read_alat.dart';
import '../kategori/read_kategori.dart';
import '../../../auth/logout.dart';

class ReadUser extends StatefulWidget {
  const ReadUser({super.key});

  @override
  State<ReadUser> createState() => _ReadUserState();
}

class _ReadUserState extends State<ReadUser> {
  final supabase = Supabase.instance.client;

  late final Stream<List<Map<String, dynamic>>> _userStream;

  @override
  void initState() {
    super.initState();
    // 2. WAJIB Inisialisasi stream di sini agar tidak error 'LateInitializationError'
    _userStream = supabase.from('users').stream(primaryKey: ['user_id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Halaman User', 
          style: TextStyle(
            color: Colors.white, 
            fontSize: 18, 
            fontWeight: FontWeight.bold
          )
        ),
        backgroundColor: const Color(0xFF756F6F),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Bar Pencarian
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF756F6F),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Cari',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                  prefixIcon: Icon(Icons.search, color: Colors.white, size: 30),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ),

          // List User dengan StreamBuilder
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _userStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Tidak ada data user"));
                }

                final users = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    // Logika Inisial Otomatis (Mengambil huruf pertama dari nama)
                    final String nama = user['nama'] ?? 'User';
                    final String initial = nama.isNotEmpty ? nama[0].toUpperCase() : '?';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade400, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: const Color(0xFFEBE5E5),
                              child: Text(
                                initial, // Menggunakan inisial otomatis
                                style: const TextStyle(
                                  fontSize: 35,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama: ${user['nama'] ?? ''}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  Text('Email: ${user['email'] ?? ''}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  Text('Role: ${user['role'] ?? ''}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateUserPage(user: user),
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.edit_note, color: Colors.grey.shade700, size: 30),
                                ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DeleteUserPage(
                                      userId: user['user_id'].toString(),
                                      onDeleted: () {
                                        setState(() {}); // Refresh list setelah delete
                                      },
                                    ),
                                  ),
                                );
                              },
                                child: Icon(Icons.delete, color: Colors.grey.shade700, size: 25),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Tombol Tambah User
          Padding(
            padding: const EdgeInsets.only(bottom: 40, right: 30),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateUser()),
                  );
                  setState(() {}); 
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Tambah User',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
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

      /// ✅ NAVBAR BARU
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2, // Index 2 untuk Halaman User
        selectedItemColor: Colors.grey[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) return; // Jangan refresh jika menekan tab yang sama
          Widget target;
          if (index == 0) target = const HomeDashboardAdmin();
          else if (index == 1) target = const ReadAlatPage();
          else if (index == 3) target = const ReadKategori();
          else if (index == 4) target = const LogoutPage();
          else return;

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => target));
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