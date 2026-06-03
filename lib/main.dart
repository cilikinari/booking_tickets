import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 🟢 1. Pastikan import provider
import 'domain/providers/movie_provider.dart'; // 🟢 2. Sesuaikan dengan path MovieProvider-mu
import 'presentation/screens/home_unauth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🟢 3. Bungkus MaterialApp kamu dengan MultiProvider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        // Nanti kalau ada AuthProvider atau TicketProvider tinggal tambah di bawah sini
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bioskop App',
        theme: ThemeData.dark(), // Sesuaikan dengan tema aplikasimu
        home: const HomeUnauthScreen(),
      ),
    );
  }
}
