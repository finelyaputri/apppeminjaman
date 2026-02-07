import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://knixrkxjxbxcnybklebk.supabase.co',
    anonKey: 'sb_publishable_-uLVxl34Nor8rd4Z2_hFRA_Xv4v-Ml3',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SipaloSplashScreen(),
    );
  }
}
