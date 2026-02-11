import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  String? selectedRole;
  bool _obscureText = true;

  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Gunakan huruf kecil agar sesuai dengan Constraint Database (admin, petugas, peminjam)
  final List<String> roles = ['admin', 'petugas', 'peminjam'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF756F6F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah User Baru',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView( // Agar tidak error overflow saat keyboard muncul
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Nama'),
              _buildTextField('Masukkan nama', namaController),
              const SizedBox(height: 20),
              _buildLabel('Email'),
              _buildTextField('Masukkan email', emailController),
              const SizedBox(height: 20),
              _buildLabel('Kata Sandi'),
              _buildPasswordField(),
              const SizedBox(height: 20),
              _buildLabel('Role'),
              _buildDropdownField(),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildButton(
                    'Batal',
                    Colors.white,
                    Colors.grey.shade700,
                    onPressed: () => Navigator.pop(context),
                    hasBorder: true,
                  ),
                  const SizedBox(width: 10),
                  _buildButton(
                    'Tambah User',
                    const Color(0xFF756F6F),
                    Colors.white,
                    onPressed: _handleTambahUser, // Pindah logika ke fungsi terpisah
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- LOGIKA UTAMA ---
  Future<void> _handleTambahUser() async {
    final nama = namaController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // 1. Validasi Input
    if (nama.isEmpty || email.isEmpty || password.isEmpty || selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua kolom!')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password minimal 6 karakter!')),
      );
      return;
    }

    try {
      // 2. Gunakan signUp (WAJIB agar bisa login & Trigger SQL jalan)
      final res = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {}, // kosongkan agar role tidak default
      );

      if (res.user != null) {
        // Simpan nama & role ke tabel users
        await Supabase.instance.client
            .from('users')
            .update({'nama': nama, 'role': selectedRole})
            .eq('user_id', res.user!.id)
            .select();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User berhasil ditambahkan!')),
          );
          Navigator.pop(context); // kembali ke ReadUser
        }
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e')),
        );
      }
    }
  }

  // --- WIDGET HELPER (Tetap Sama) ---
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: 'Minimal 6 karakter',
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedRole,
          hint: const Text('Pilih role'),
          isExpanded: true,
          items: roles.map((role) => DropdownMenuItem(
            value: role, 
            child: Text(role[0].toUpperCase() + role.substring(1)) // Tampilan Kapital
          )).toList(),
          onChanged: (val) => setState(() => selectedRole = val),
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color bgColor, Color textColor, {required VoidCallback onPressed, bool hasBorder = false}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: hasBorder ? BorderSide(color: Colors.grey.shade400) : BorderSide.none,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Text(text),
    );
  }
}