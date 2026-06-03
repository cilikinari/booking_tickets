import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/booking_provider.dart';
import '../../utils/constants.dart';
import '../widgets/seat.dart';
import '../widgets/booking_info.dart';
import 'payment_screen.dart';

// 🟢 SEKARANG BISA MENJADI STATELESSWIDGET (Ringan dan bebas dari penampungan state lokal)
class SeatScreen extends StatelessWidget {
  const SeatScreen({super.key});

  void _onBooking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // 🟢 SEKARANG CONSTRUCTOR PAYMENTSCREEN MENJADI SANGAT BERSIH!
        // PaymentScreen tinggal membaca semua data transaksi dari BookingProvider global.
        builder: (_) => const PaymentScreen(), 
      ),
    );
  }

  ScrollPhysics get _scrollPhysics =>
      kIsWeb ? const ClampingScrollPhysics() : const BouncingScrollPhysics();

  bool get _isDesktopOrWeb =>
      kIsWeb ||
      switch (defaultTargetPlatform) {
        TargetPlatform.windows => true,
        TargetPlatform.macOS => true,
        TargetPlatform.linux => true,
        _ => false,
      };

  double _calcSeatGridWidth(BuildContext context) {
    const seatsPerRow = 10;
    const aisleWidth = 18.0;
    const gridPadding = 32.0;
    const totalSeatSpacing = 60.0;

    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth.clamp(0.0, AppConstants.maxWidth);
    final usable = contentWidth - gridPadding - aisleWidth - totalSeatSpacing;
    final size = (usable / seatsPerRow).clamp(24.0, 52.0);

    return (seatsPerRow * size) + aisleWidth + totalSeatSpacing;
  }

  @override
  Widget build(BuildContext context) {
    // 🟢 Ambil instance data transaksi aktif dari BookingProvider
    final bookingProvider = Provider.of<BookingProvider>(context);
    final movie = bookingProvider.activeMovie;

    if (movie == null) {
      return Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: const Center(
          child: Text('No movie selected', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        leading: const BackButton(color: Colors.white),
        title: Text(
          movie.title,
          style: const TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppConstants.maxWidth),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: _scrollPhysics,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      // Layout susunan kursi bioskop
                      CinemaSeatLayout(
                        onSelectionChanged: (seats) {
                          // 🟢 Kirim daftar kursi terbaru langsung ke provider bisnis Anda
                          bookingProvider.updateSelectedSeats(seats);
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: BookingInfo(
                    // 🟢 SEMUA DATA DIBAWAH INI SEKARANG DIALIRKAN DARI PROVIDER
                    totalPrice: bookingProvider.totalPrice,
                    selectedLabels: bookingProvider.selectedLabels,
                    barWidth: _calcSeatGridWidth(context),
                    isDesktopOrWeb: _isDesktopOrWeb,
                    onBooking: bookingProvider.selectedSeats.isEmpty
                        ? null
                        : () => _onBooking(context), // 🟢 Fungsi pemicu navigasi bersih
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
