import 'package:flutter/material.dart';

class AjukanPeminjamanPage extends StatefulWidget {
  final String namaAlat;
  final String status;
  final String kondisi;
  final String imageUrl;

  const AjukanPeminjamanPage({
    super.key,
    required this.namaAlat,
    required this.status,
    required this.kondisi,
    required this.imageUrl,
  });

  @override
  State<AjukanPeminjamanPage> createState() => _AjukanPeminjamanPageState();
}

class _AjukanPeminjamanPageState extends State<AjukanPeminjamanPage> {
  int jumlah = 1;
  DateTime? tanggalPinjam;
  DateTime? tanggalKembali;

  int get totalHari {
    if (tanggalPinjam == null || tanggalKembali == null) return 0;
    return tanggalKembali!.difference(tanggalPinjam!).inDays;
  }

  Future<void> pickDate(bool isPinjam) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isPinjam) {
          tanggalPinjam = picked;
        } else {
          tanggalKembali = picked;
        }
      });
    }
  }

  String formatDate(DateTime? d) {
    if (d == null) return '';
    return "${d.day}-${d.month}-${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      appBar: AppBar(
        title: const Text('Ajukan Peminjaman'),
        backgroundColor: const Color(0xFF6F6666),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== CARD INFO ALAT =====
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: widget.imageUrl.startsWith('http')
                        ? Image.network(widget.imageUrl)
                        : Image.asset(widget.imageUrl),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama: ${widget.namaAlat}'),
                      const SizedBox(height: 6),
                      Text('Status: ${widget.status}'),
                      const SizedBox(height: 6),
                      Text('Kondisi: ${widget.kondisi}'),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ===== JUMLAH =====
            const Text(
              'Jumlah:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF6F6666),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: () {
                      if (jumlah > 1) {
                        setState(() => jumlah--);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  jumlah.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF6F6666),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      setState(() => jumlah++);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ===== TANGGAL PINJAM =====
            const Text('Tanggal Pinjam:'),
            const SizedBox(height: 6),
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: formatDate(tanggalPinjam),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF6F6666),
                hintText: 'Tanggal Pinjam',
                hintStyle: const TextStyle(color: Colors.white70),
                suffixIcon:
                    const Icon(Icons.calendar_today, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onTap: () => pickDate(true),
            ),

            const SizedBox(height: 12),

            // ===== TANGGAL KEMBALI =====
            const Text('Tanggal Kembali:'),
            const SizedBox(height: 6),
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: formatDate(tanggalKembali),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF6F6666),
                hintText: 'Tanggal Kembali',
                hintStyle: const TextStyle(color: Colors.white70),
                suffixIcon:
                    const Icon(Icons.calendar_today, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onTap: () => pickDate(false),
            ),

            const SizedBox(height: 10),

            Text('Total Hari Meminjam: $totalHari Hari'),

            const Spacer(),

            // ===== BUTTON =====
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6F6666),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {},
                    child: const Text('Ajukan Peminjaman'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}