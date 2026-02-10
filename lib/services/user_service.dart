import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class UserService {
  final _supabase = Supabase.instance.client;

  // Stream untuk Read (Realtime)
  Stream<List<UserModel>> getUserStream() {
    return _supabase
        .from('users')
        .stream(primaryKey: ['user_id'])
        .map((data) => data.map((map) => UserModel.fromMap(map)).toList());
  }

  // Create User (Auth + Insert Table)
  Future<void> createUser({
    required String nama,
    required String email,
    required String password,
    required String role,
  }) async {
    final res = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (res.user != null) {
      await _supabase.from('users').update({
        'nama': nama,
        'role': role,
      }).eq('user_id', res.user!.id);
    }
  }

  // Update User
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _supabase.from('users').update(data).eq('user_id', id);
  }

  // Delete User
  Future<void> deleteUser(String id) async {
    await _supabase.from('users').delete().eq('user_id', id);
  }
}