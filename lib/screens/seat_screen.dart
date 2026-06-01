import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/seat.dart';
import '../utils/constants.dart';
import '../widgets/seat.dart'; // Import layout grid kursi bawaan
import '../widgets/booking_info.dart'; // Import bottom bar gabungan yang baru
import 'payment_screen.dart';

class SeatScreen extends StatefulWidget {
  final Movie movie;
  final int ticketPrice;
  final String cinema;
  final String date;
  final String time;

  const SeatScreen({
    super.key,
    required this.movie,
    this.ticketPrice = AppConstants.defaultTicketPrice,
    required this.cinema,
    required this.date,
    required this.time,
  });

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  List<Seat> _selectedSeats = [];

  int get _totalPrice => _selectedSeats.length * widget.ticketPrice;

  String get _selectedLabels {
    final labels = _selectedSeats.map((s) => s.id).toList()..sort();
    return labels.isEmpty ? '-' : labels.join(', ');
  }

  void _onBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          movie: widget.movie,
          cinema: widget.cinema,
          date: widget.date,
          time: widget.time,
          seats: _selectedSeats.map((s) => s.id).toList(),
          totalPrice: _totalPrice.toDouble(),
        ),
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
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        leading: const BackButton(color: Colors.white),
        title: Text(
          widget.movie.title,
          style: const TextStyle(
            color: AppConstants.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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

                      // Menampilkan layout layar dan susunan kursi
                      CinemaSeatLayout(
                        onSelectionChanged: (seats) {
                          setState(() {
                            _selectedSeats = seats;
                          });
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
                  // Cukup panggil satu widget ini, legend sudah otomatis include di dalamnya
                  child: BookingInfo(
                    totalPrice: _totalPrice,
                    selectedLabels: _selectedLabels,
                    barWidth: _calcSeatGridWidth(context),
                    isDesktopOrWeb: _isDesktopOrWeb,
                    onBooking: _selectedSeats.isEmpty ? null : _onBooking,
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
