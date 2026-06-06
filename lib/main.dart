import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'domain/providers/movie_provider.dart'; 
import 'domain/providers/booking_provider.dart'; 
import 'domain/providers/history_provider.dart'; 
import 'domain/providers/auth_provider.dart';
import 'domain/providers/seat_provider.dart'; // 🟢 1. Tambahkan import SeatProvider
import 'presentation/screens/home_unauth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()), 
        ChangeNotifierProvider(create: (_) => SeatProvider()), // 🟢 2. Masukkan ke keranjang
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cinema +',
        theme: ThemeData.dark(), 
        home: const HomeUnauthScreen(),
      ),
    );
  }
}