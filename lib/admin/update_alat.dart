import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class UpdateAlatPage extends StatefulWidget {
  final Map<String, dynamic>? alat; // Menerima data alat jika ada

  const UpdateAlatPage({super.key, this.alat});

  @override
  State<UpdateAlatPage> createState() => _UpdateAlatPageState();
}

class _UpdateAlatPageState extends State<UpdateAlatPage> {
  late TextEditingController _namaAlatController;
  late TextEditingController _statusController;
  late TextEditingController _stokController;
  String _selectedKategori = "Sepak Bola";
  Uint8List? _webImage; // Untuk menyimpan image baru

  final List<String> _kategoriList = ["Sepak Bola", "Badminton", "Voli"];
  final Color _headerColor = const Color(0xFF756F6F);

  @override
  void initState() {
    super.initState();
    final alat = widget.alat;
    _namaAlatController = TextEditingController(text: alat?['nama_alat'] ?? '');
    _statusController = TextEditingController(text: alat?['status'] ?? 'Tersedia');
    _stokController = TextEditingController(text: alat?['stok']?.toString() ?? '0');
    _selectedKategori = alat?['kategori'] ?? 'Sepak Bola';
  }

  @override
  void dispose() {
    _namaAlatController.dispose();
    _statusController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final f = await pickedFile.readAsBytes();
      setState(() {
        _webImage = f;
      });
    }
  }

  Future<void> _updateAlat() async {
    final supabase = Supabase.instance.client;
    final alatId = widget.alat?['alat_id'];
    if (alatId == null) return;

    String gambarUrl = widget.alat?['gambar'] ?? 'assets/default.png';

    try {
      // Upload gambar baru jika ada
      if (_webImage != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
        await supabase.storage.from('alat_bucket').uploadBinary(fileName, _webImage!);
        gambarUrl = supabase.storage.from('alat_bucket').getPublicUrl(fileName);
      }

      // Update data di Supabase
      await supabase.from('alat').update({
        'nama_alat': _namaAlatController.text,
        'status': _statusController.text,
        'stok': int.tryParse(_stokController.text) ?? 0,
        'kategori': _selectedKategori,
        'gambar': gambarUrl,
      }).eq('alat_id', alatId);

      if (!mounted) return;
      Navigator.pop(context, true); // Kirim signal ke ReadAlatPage untuk refresh
    } catch (e) {
      debugPrint("Error update: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentImage = _webImage != null
        ? '' // Akan ditampilkan Image.memory nanti
        : widget.alat?['gambar'] ?? 'assets/default.png';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Update Alat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _headerColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Foto Produk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF616161))),
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: _webImage != null
                      ? Image.memory(_webImage!, fit: BoxFit.contain)
                      : (currentImage.startsWith('http')
                          ? Image.network(currentImage, fit: BoxFit.contain)
                          : Image.asset(currentImage, fit: BoxFit.contain)),
                ),
              ),
            ),
            const SizedBox(height: 25),
            _buildInputField("Nama Alat", _namaAlatController),
            const SizedBox(height: 20),
            _buildInputField("Status", _statusController),
            const SizedBox(height: 20),
            _buildInputField("Stok", _stokController, isNumber: true),
            const SizedBox(height: 20),
            const Text('Kategori', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF616161))),
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
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Batal', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    onPressed: _updateAlat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _headerColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF616161))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade400)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade400)),
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
