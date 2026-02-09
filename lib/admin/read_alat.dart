import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'create_alat.dart';
import 'delete_alat.dart';
import 'update_alat.dart'; 

class ReadAlatPage extends StatefulWidget {
  const ReadAlatPage({super.key});

  @override
  State<ReadAlatPage> createState() => _ReadAlatPageState();
}

class _ReadAlatPageState extends State<ReadAlatPage> {
  Future<List<Map<String, dynamic>>> _getAlat() async {
    final supabase = Supabase.instance.client;
    final res = await supabase.from('alat').select();
    return List<Map<String, dynamic>>.from(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF756D6D),
        title: const Text('Daftar Alat', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateProdukPage()),
          );
          setState(() {});
        },
        backgroundColor: const Color(0xFF756D6D),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder(
        future: _getAlat(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snapshot.data!;
          if (list.isEmpty) {
            return const Center(child: Text("Belum ada data alat"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final a = list[i];
              String pathGambar = (a['gambar'] ?? 'assets/default.png').toString().trim();

              return _buildAlatItem(
                a['nama_alat'] ?? '-',
                a['stok'].toString(),
                a['status'] ?? '—',
                imgPath: pathGambar,
                id: a['alat_id'], 
                a: a,
              );
            },
          );
        },
      ),
    );
  }

  // 📍 PERBAIKAN 2: Tambahkan parameter id (opsional tapi disarankan)
 Widget _buildAlatItem(String name, String stock, String status, {String? imgPath, dynamic id, required Map<String, dynamic> a}) {
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
          Container(
  width: 80,
  height: 60,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
  ),
  child: imgPath != null
      ? (imgPath.startsWith('http')
          ? Image.network(
              imgPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, color: Colors.grey);
              },
            )
          : Image.asset(
              imgPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, color: Colors.grey);
              },
            ))
      : const Icon(Icons.inventory),
),

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Stok : $stock'),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(status, style: const TextStyle(color: Colors.green)),
                    Row(
  children: [
    // 📍 PERBAIKAN: Bungkus Icon Edit dengan GestureDetector
    GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UpdateAlatPage(alat: a), // 'a' adalah data Map alat dari loop
          ),
        );
        setState(() {}); // Refresh data setelah kembali dari halaman update
      },
      child: Icon(Icons.edit_note, color: Colors.grey[700], size: 28),
    ),
                        const SizedBox(width: 8),
                        // 📍 PERBAIKAN 3: Bungkus Icon dengan GestureDetector
                        GestureDetector(
                          onTap: () {
                            DeleteAlat.showDeleteDialog(
                              context,
                              onConfirm: () async {
                                // PERBAIKAN UTAMA: Gunakan await di sini
                                final supabase = Supabase.instance.client;
                                try {
                                  await supabase.from('alat').delete().eq('alat_id', id);
                                  // Refresh UI setelah dipastikan data terhapus di database
                                  setState(() {}); 
                                } catch (e) {
                                  debugPrint("Error hapus: $e");
                                }
                              },
                            );
                          },
                          child: Icon(Icons.delete_outline, color: Colors.grey[700], size: 26),
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