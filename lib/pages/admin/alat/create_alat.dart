import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import untuk kIsWeb
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//// === PERBAIKAN === (WAJIB untuk Uint8List)
import 'dart:typed_data';


class CreateProdukPage extends StatefulWidget {
  const CreateProdukPage({super.key});

  @override
  State<CreateProdukPage> createState() => _CreateProdukPageState();
}

class _CreateProdukPageState extends State<CreateProdukPage> {

//// ===== TAMBAHAN =====
final _namaC = TextEditingController();
final _statusC = TextEditingController();
final _stokC = TextEditingController();
String? _kategori;

  Uint8List? _webImage; 

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var f = await pickedFile.readAsBytes();
      setState(() {
        _webImage = f;
      });
    }
  }

Future<void> _simpanAlat() async {
  try {
    final supabase = Supabase.instance.client;

    // ===== PERBAIKAN UTAMA: Upload gambar jika ada
    String gambarUrl = 'assets/default.png'; // default jika tidak pilih gambar

    if (_webImage != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      await supabase.storage.from('alat_bucket').uploadBinary(fileName, _webImage!);
      gambarUrl = supabase.storage.from('alat_bucket').getPublicUrl(fileName);
    } else {
      // Kalau masih pakai kategori statis, tetap bisa pilih gambar default
      if (_kategori == 'Sepak Bola') gambarUrl = 'assets/bola.png';
      if (_kategori == 'Voli') gambarUrl = 'assets/voli.png';
      if (_kategori == 'Badminton') gambarUrl = 'assets/raket.png';
    }

    int kategoriId = 0;
    if (_kategori == 'Sepak Bola') kategoriId = 1;
    if (_kategori == 'Badminton') kategoriId = 3;
    if (_kategori == 'Voli') kategoriId = 4;

    await supabase.from('alat').insert({
      'nama_alat': _namaC.text,
      'status': _statusC.text.isEmpty ? 'Tersedia' : _statusC.text,
      'stok': int.tryParse(_stokC.text) ?? 0,
      'kategori_id': kategoriId,
      'gambar': gambarUrl, // simpan URL gambar dari Storage atau asset
    });

    if (!mounted) return;
    Navigator.pop(context, true);

  } catch (e) {
    debugPrint("INSERT ERROR: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal simpan: $e')),
    );
  }
}


//// === PERBAIKAN (aman, tidak ubah struktur UI) ===
@override
void dispose() {
  _namaC.dispose();
  _statusC.dispose();
  _stokC.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF756D6D),
        title: const Text(
          'Tambah Alat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Foto Produk',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: _webImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(_webImage!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_outlined, size: 50, color: Colors.grey[600]),
                          const SizedBox(height: 8),
                          Text(
                            'Klik untuk upload foto produk',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel('Nama Alat'),
            _buildTextField('Masukkan nama alat', _namaC),

            _buildLabel('Status'),
            _buildTextField('Masukkan status', _statusC),

            _buildLabel('Stok'),
            _buildTextField('0', _stokC),

            _buildLabel('Kategori'),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              hint: const Text('Pilih kategori', style: TextStyle(color: Colors.grey)),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: <String>['Sepak Bola', 'Voli', 'Badminton']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _kategori = newValue;
              });
              },

            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                //// === PERBAIKAN ===
                /// BATAL → hanya kembali
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),

                const SizedBox(width: 10),

                //// === PERBAIKAN ===
                /// TAMBAH → simpan ke Supabase
                ElevatedButton(
  onPressed: () {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      // Kalau belum login, tampilkan pesan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu')),
      );
      return; // hentikan proses
    }
    _simpanAlat(); // Kalau sudah login, lanjut simpan
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF756D6D),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  ),
  child: const Text('Tambah Alat', style: TextStyle(color: Colors.white)),
),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
