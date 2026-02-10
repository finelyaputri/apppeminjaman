class UserModel {
  final String userId;
  final String nama;
  final String email;
  final String role;
  final String? initial;

  UserModel({
    required this.userId,
    required this.nama,
    required this.email,
    required this.role,
    this.initial,
  });

  // Mengubah Map dari Supabase ke Object Flutter
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'] ?? '',
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'peminjam',
      initial: map['nama'] != null ? map['nama'][0].toUpperCase() : '?',
    );
  }

  // Mengubah Object ke Map untuk disimpan ke DB
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'role': role,
    };
  }
}