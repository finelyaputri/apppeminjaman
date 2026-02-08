import 'package:flutter/material.dart';

class UpdateUserPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const UpdateUserPage({super.key, required this.user});

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  
  // 1. Definisikan list opsi role agar konsisten
  final List<String> _roleOptions = ['admin', 'user', 'petugas'];
  String _selectedRole = 'user'; // Nilai default

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.user['nama'] ?? "");
    _emailController = TextEditingController(text: widget.user['email'] ?? "");
    _passwordController = TextEditingController(text: widget.user['password'] ?? ""); 

    // 2. PEMBENARAN: Validasi role dari database
    // Mengonversi ke lowercase untuk menghindari kesalahan case-sensitive
    String roleFromDb = (widget.user['role'] ?? 'user').toString().toLowerCase();

    if (_roleOptions.contains(roleFromDb)) {
      _selectedRole = roleFromDb;
    } else {
      // Jika tidak ditemukan di list, gunakan default agar tidak crash
      _selectedRole = _roleOptions[1]; // default ke 'user'
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Update User',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF706C6C),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Nama"),
            _buildTextField(_namaController),
            const SizedBox(height: 20),
            
            _buildLabel("Email"),
            _buildTextField(_emailController),
            const SizedBox(height: 20),
            
            _buildLabel("Kata Sandi"),
            _buildTextField(_passwordController, isPassword: true),
            const SizedBox(height: 20),
            
            _buildLabel("Role"),
            _buildDropdown(),
            
            const Spacer(),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF706C6C)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  ),
                  child: const Text(
                    "Batal",
                    style: TextStyle(color: Color(0xFF706C6C)),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Tambahkan logika update Supabase di sini
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF706C6C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  ),
                  child: const Text(
                    "Update User",
                    style: TextStyle(color: Colors.white),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF616161),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        suffixIcon: isPassword 
            ? const Icon(Icons.visibility_off_outlined, color: Colors.grey) 
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF706C6C)),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedRole,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          // 3. Gunakan list variabel agar sinkron dengan initState
          items: _roleOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.grey)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedRole = newValue!;
            });
          },
        ),
      ),
    );
  }
}