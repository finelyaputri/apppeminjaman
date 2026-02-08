import 'package:flutter/material.dart';

class UpdateAlatPage extends StatefulWidget {
  final Map<String, dynamic>? alat; // Menerima data alat jika ada

  const UpdateAlatPage({super.key, this.alat});

  @override
  State<UpdateAlatPage> createState() => _UpdateAlatPageState();
}

class _UpdateAlatPageState extends State<UpdateAlatPage> {
  // Controller untuk input teks
  final TextEditingController _namaAlatController =
      TextEditingController(text: "Bola Sepak");
  final TextEditingController _statusController =
      TextEditingController(text: "Tersedia");
  final TextEditingController _stokController =
      TextEditingController(text: "10");
  
  String _selectedKategori = "Sepak Bola";
  final List<String> _kategoriList = ["Sepak Bola", "Basket", "Voli", "Tenis"];

  // Warna abu-abu gelap sesuai header gambar
  final Color _headerColor = const Color(0xFF756F6F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Update Alat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _headerColor,
        elevation: 0,
        automaticallyImplyLeading: false, // Menghilangkan tombol back default
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label Foto Produk
            const Text(
              'Foto Produk',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 10),
            
            // Container Foto Produk dengan Icon Edit
            Center(
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade400),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Gambar Produk (Bola)
                    Center(
                      child: Image.network(
                        'https://cdn-icons-png.flaticon.com/512/53/53254.png', // Placeholder bola
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Icon Edit di Pojok Kanan Atas
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          // Logika ganti foto
                        },
                        child: Icon(
                          Icons.edit_note,
                          color: _headerColor,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Input Nama Alat
            _buildInputField("Nama Alat", _namaAlatController),
            const SizedBox(height: 20),

            // Input Status
            _buildInputField("Status", _statusController),
            const SizedBox(height: 20),

            // Input Stok
            _buildInputField("Stok", _stokController, isNumber: true),
            const SizedBox(height: 20),

            // Dropdown Kategori
            const Text(
              'Kategori',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedKategori,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, size: 30),
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedKategori = newValue!;
                    });
                  },
                  items: _kategoriList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 100), // Memberi ruang untuk tombol bawah

            // Baris Tombol Batal & Simpan
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Batal
                SizedBox(
                  width: 100,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Tombol Simpan Perubahan
                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logika update ke database
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _headerColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Label + TextField
  Widget _buildInputField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF616161),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}