import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // pastikan path sesuai

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // ini penting (biar ga warning)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), // 👈 INI YANG NAMPILIN UI KAMU
    );
  }
}
