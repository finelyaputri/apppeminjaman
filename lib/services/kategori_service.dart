import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/kategori_model.dart';

class KategoriService {
  final _supabase = Supabase.instance.client;

  // Stream untuk Read (Real-time)
  Stream<List<KategoriModel>> getKategoriStream() {
    return _supabase
        .from('kategori')
        .stream(primaryKey: ['kategori_id'])
        .order('nama_kategori')
        .map((data) => data.map((e) => KategoriModel.fromMap(e)).toList());
  }

  // Insert
  Future<void> addKategori(KategoriModel kategori) async {
    await _supabase.from('kategori').insert(kategori.toMap());
  }

  // Update
  Future<void> updateKategori(KategoriModel kategori) async {
    await _supabase
        .from('kategori')
        .update(kategori.toMap())
        .eq('kategori_id', kategori.id!);
  }

  // Delete
  Future<void> deleteKategori(int id) async {
    await _supabase.from('kategori').delete().eq('kategori_id', id);
  }
}