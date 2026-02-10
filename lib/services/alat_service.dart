import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/alat_model.dart';

class AlatService {
  final _supabase = Supabase.instance.client;

  // Mendapatkan semua data alat
  Future<List<Alat>> fetchAlat() async {
    final response = await _supabase.from('alat').select();
    return (response as List).map((map) => Alat.fromMap(map)).toList();
  }

  // Menambah alat baru + Upload Gambar
  Future<void> createAlat(Alat alat, Uint8List? imageBytes) async {
    String finalUrl = alat.gambar;

    if (imageBytes != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      await _supabase.storage.from('alat_bucket').uploadBinary(fileName, imageBytes);
      finalUrl = _supabase.storage.from('alat_bucket').getPublicUrl(fileName);
    }

    await _supabase.from('alat').insert(alat.toMap()..['gambar'] = finalUrl);
  }

  // Menghapus alat
  Future<void> deleteAlat(int id) async {
    await _supabase.from('alat').delete().eq('alat_id', id);
  }
  
  // Update alat
  Future<void> updateAlat(int id, Alat alat, Uint8List? imageBytes) async {
    String finalUrl = alat.gambar;

    if (imageBytes != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      await _supabase.storage.from('alat_bucket').uploadBinary(fileName, imageBytes);
      finalUrl = _supabase.storage.from('alat_bucket').getPublicUrl(fileName);
    }

    await _supabase.from('alat').update(alat.toMap()..['gambar'] = finalUrl).eq('alat_id', id);
  }
}