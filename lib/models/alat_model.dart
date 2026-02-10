class Alat {
  final int? id;
  final String nama;
  final String status;
  final int stok;
  final String gambar;
  final int kategoriId;

  Alat({
    this.id,
    required this.nama,
    required this.status,
    required this.stok,
    required this.gambar,
    required this.kategoriId,
  });

  // Untuk mengubah data dari Supabase (Map) menjadi Object Flutter
  factory Alat.fromMap(Map<String, dynamic> map) {
    return Alat(
      id: map['alat_id'],
      nama: map['nama_alat'] ?? '',
      status: map['status'] ?? 'Tersedia',
      stok: map['stok'] ?? 0,
      gambar: map['gambar'] ?? 'assets/default.png',
      kategoriId: map['kategori_id'] ?? 0,
    );
  }

  // Untuk mengubah Object Flutter menjadi Map sebelum dikirim ke Supabase
  Map<String, dynamic> toMap() {
    return {
      'nama_alat': nama,
      'status': status,
      'stok': stok,
      'gambar': gambar,
      'kategori_id': kategoriId,
    };
  }
}