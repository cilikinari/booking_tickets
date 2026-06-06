import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../../utils/constants.dart';
import '../screens/seat_screen.dart';
import '../../domain/providers/auth_provider.dart'; 
import '../../domain/providers/seat_provider.dart'; 

class BookButton extends StatelessWidget {
  final int scheduleId; 
  const BookButton({super.key, required this.scheduleId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () async {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final token = authProvider.token;

          if (token == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Silakan login terlebih dahulu!')),
            );
            return; // Berhenti di sini kalau belum login
          }

          final seatProvider = Provider.of<SeatProvider>(context, listen: false);

          try {
            await seatProvider.fetchSeats(scheduleId, token); 

            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SeatScreen()),
              );
            }
          } catch (e) {
            // Munculkan error kalau API gagal
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gagal memuat kursi: $e'), 
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: const Text(
          "Book Now",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}