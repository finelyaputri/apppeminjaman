import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class UpdateKategori extends StatefulWidget {
  final Map<String, dynamic> kategori;

  const UpdateKategori({
    super.key,
    required this.kategori,
  });


  @override
  State<UpdateKategori> createState() => _UpdateKategoriState();
}

class _UpdateKategoriState extends State<UpdateKategori> {

  // controller tetap ada untuk isi field
  final TextEditingController namaController = TextEditingController();

  @override
void initState() {
  super.initState();
  namaController.text = widget.kategori['nama_kategori']?.toString() ?? '';
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Update Kategori',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF756D6D),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Card Utama
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Nama Kategori',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF756D6D),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Input Field
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nama Kategori Baru',
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Tombol Update
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final namaBaru = namaController.text.trim();

                        if (namaBaru.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Nama kategori tidak boleh kosong')),
                            );
                            return;
                          }

                          await Supabase.instance.client
                            .from('kategori')
                            .update({
                              'nama_kategori': namaBaru,
                            })
                            .eq('kategori_id', widget.kategori['kategori_id']); // ← pakai id kategori

                            // kembali ke halaman read + kirim sinyal berhasil
                            Navigator.pop(context, true);
                          },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF756D6D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Update Kategori',
                        style:
                            TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tombol Batal
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style:
                            TextStyle(color: Colors.grey, fontSize: 16),
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
}
