class KategoriModel {
  final int? id;
  final String namaKategori;

  KategoriModel({this.id, required this.namaKategori});

  // Konversi dari Map (Supabase) ke Objek Dart
  factory KategoriModel.fromMap(Map<String, dynamic> map) {
    return KategoriModel(
      id: map['kategori_id'],
      namaKategori: map['nama_kategori'] ?? '',
    );
  }

  // Konversi dari Objek Dart ke Map (untuk Insert/Update)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'kategori_id': id,
      'nama_kategori': namaKategori,
    };
  }
}