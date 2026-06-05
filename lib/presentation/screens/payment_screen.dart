import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/booking_provider.dart';
import '../../data/models/booking.dart';
import '../../utils/constants.dart';
import '../widgets/countdown_banner.dart';
import '../widgets/order_summary.dart';
import '../widgets/payment_method.dart';
import '../widgets/timeout_dialog.dart';
import 'home_screen.dart';
import 'success_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isTimeoutDialogVisible = false;

  @override
  void initState() {
    super.initState();
    // 🟢 Nyalakan bisnis timer di provider saat halaman ini pertama kali terbuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BookingProvider>(context, listen: false);
      provider.startPaymentTimer(() {
        _showTimeoutDialog();
      });
    });
  }

  @override
  void dispose() {
    // 🟢 Amankan memori dengan mematikan timer di provider saat keluar halaman
    final provider = Provider.of<BookingProvider>(context, listen: false);
    provider.stopTimer();
    super.dispose();
  }

  Future<void> _showTimeoutDialog() async {
    if (_isTimeoutDialogVisible || !mounted) return;
    _isTimeoutDialogVisible = true;

    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return TimeoutDialog(
            onGotIt: () {
              Navigator.of(dialogContext).pop();
              _goHome();
            },
          );
        },
      );
    } finally {
      _isTimeoutDialogVisible = false;
    }
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  void _onPayNow(BookingProvider provider) {
    if (!provider.canPay) return;

    // 🟢 Minta provider untuk menyelesaikan transaksi dan merakit objek Booking jadi
    final Booking finalBooking = provider.completePayment();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => SuccessScreen(booking: finalBooking)),
    );
  }

  ScrollPhysics get _scrollPhysics =>
      kIsWeb ? const ClampingScrollPhysics() : const BouncingScrollPhysics();

  @override
  Widget build(BuildContext context) {
    // Mendengarkan perubahan state pembayaran secara global dari provider
    final bookingProvider = Provider.of<BookingProvider>(context);
    final movie = bookingProvider.activeMovie;

    if (movie == null) {
      return const Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: Center(child: Text('No active booking')),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 900;
    final horizontalPadding = isWide ? AppConstants.padding : 16.0;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Payment Details',
          style: TextStyle(
            color: AppConstants.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxWidth),
            child: SingleChildScrollView(
              physics: _scrollPhysics,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isWide
                      ? _buildDesktopLayout(bookingProvider)
                      : _buildMobileLayout(bookingProvider),
                  const SizedBox(height: 32),
                  _buildPayButton(isWide, bookingProvider),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BookingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CountdownBanner(formattedCountdown: provider.formattedCountdown),
        const SizedBox(height: 32),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Kiri: Metode Pembayaran
              Expanded(
                flex: 5, // 🟢 Beri rasio ruang 5
                child: PaymentMethodsCard(
                  selectedPayment: provider.selectedPayment,
                  onMethodSelected: (method) =>
                      provider.selectPaymentMethod(method),
                ),
              ),
              const SizedBox(width: 48),

              // Bagian Kanan: Ringkasan Pesanan (Dibuat Responsif)
              Expanded(
                flex: 4, // 🟢 Ganti SizedBox dengan Expanded agar fleksibel
                child: Padding(
                  padding: const EdgeInsets.only(top: 42),
                  child: OrderSummaryCard(
                    movie: provider.activeMovie!,
                    cinema: provider.selectedCinema,
                    date: provider.selectedDate,
                    time: provider.selectedTime,
                    seats: provider.selectedSeats.map((s) => s.id).toList(),
                    totalPrice: provider.totalPrice.toDouble(),
                    // 🟢 Ukuran poster sedikit dirapikan
                    posterHeight: 280,
                    posterWidth: 180,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BookingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CountdownBanner(formattedCountdown: provider.formattedCountdown),
        const SizedBox(height: 20),
        OrderSummaryCard(
          movie: provider.activeMovie!,
          cinema: provider.selectedCinema,
          date: provider.selectedDate,
          time: provider.selectedTime,
          seats: provider.selectedSeats.map((s) => s.id).toList(),
          totalPrice: provider.totalPrice.toDouble(),
          posterHeight: 170,
          posterWidth: 120,
        ),
        const SizedBox(height: 28),
        PaymentMethodsCard(
          selectedPayment: provider.selectedPayment,
          onMethodSelected: (method) => provider.selectPaymentMethod(method),
        ),
      ],
    );
  }

  Widget _buildPayButton(bool isWide, BookingProvider provider) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 28, bottom: 20),
        width: isWide ? 360 : double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            disabledBackgroundColor: AppConstants.primaryColor.withOpacity(
              0.45,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          // 🟢 Gunakan tombol berdasarkan kondisi boolean canPay milik provider bisnis Anda
          onPressed: provider.canPay ? () => _onPayNow(provider) : null,
          child: Text(
            provider.canPay
                ? 'Pay Now · Rp ${provider.totalPrice}' // Sederhanakan pemanggilan mata uang untuk contoh ini
                : 'Select Payment Method',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
