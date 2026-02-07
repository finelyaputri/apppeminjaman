import 'package:flutter/material.dart';
import 'login.dart';

class SipaloSplashScreen extends StatefulWidget {
  const SipaloSplashScreen({super.key});

  @override
  State<SipaloSplashScreen> createState() => _SipaloSplashScreenState();
}

class _SipaloSplashScreenState extends State<SipaloSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121), // abu-abu luar
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: 9 / 19,
            child: Container(
              margin: const EdgeInsets.all(20),
              color: Colors.white,
              child: Stack(
                children: [

                  // LOGO CENTER (ASSET)
                  Center(
                    child: Container(
                      width: 260,
                      height: 260,
                      color: const Color(0xFFFDFDF5), // putih gading
                      child: Center(
                        child: Image.asset(
                          'assets/logo_sipalo.png',
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
