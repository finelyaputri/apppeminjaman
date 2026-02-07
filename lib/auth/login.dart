import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../admin/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  String? emailError;
  String? passwordError;

  // ============================
  // 🔧 PERBAIKAN (HANYA DI SINI)
  // ============================
  Future<void> login() async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response =
          await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // ✅ LOGIN BERHASIL → MASUK DASHBOARD ADMIN
      if (response.user != null) {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeDashboardAdmin(),
          ),
        );
      }
    } on AuthException catch (e) {
      final message = e.message.toLowerCase();

      // 🔴 EMAIL SALAH / TIDAK TERDAFTAR
      if (message.contains('email') || message.contains('user not found')) {
        setState(() {
          emailError = "Email yang anda masukkan salah";
        });
      }
      // 🔐 PASSWORD SALAH (TETAP SESUAI VALIDASI AWAL KAMU)
      else if (message.contains('invalid login credentials')) {
        setState(() {
          passwordError = "Kata sandi salah";
        });
      }
    } catch (_) {
      setState(() {
        passwordError = "Gagal terhubung ke server";
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/logo_sipalo.png',
                  height: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),

                /// EMAIL FIELD
                TextFormField(
                  controller: emailController,
                  onChanged: (val) {
                    if (emailError != null) setState(() => emailError = null);
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Masukkan email',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.email, color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey.shade600,
                    errorText: emailError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Email harus diisi'
                          : null,
                ),

                const SizedBox(height: 20),

                /// PASSWORD FIELD
                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  onChanged: (val) {
                    if (passwordError != null) {
                      setState(() => passwordError = null);
                    }
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Masukkan kata sandi',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () =>
                          setState(() => obscurePassword = !obscurePassword),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade600,
                    errorText: passwordError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Kata sandi harus diisi'
                          : null,
                ),

                const SizedBox(height: 35),

                /// LOGIN BUTTON
                SizedBox(
                  width: 160,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
