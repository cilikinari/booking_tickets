import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/booking_provider.dart';
import '../../domain/providers/auth_provider.dart';
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
  
  BookingProvider? _bookingProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initBookingLock(); 
    });
  }

  Future<void> _initBookingLock() async {
    _bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    if (token == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
    );

    try {
      await _bookingProvider!.lockSeats(token);
      
      if (!mounted) return;
      Navigator.pop(context);
      
      _bookingProvider!.startPaymentTimer(_showTimeoutDialog);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Tutup loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    // Matikan timer dengan aman
    _bookingProvider?.stopTimer();
    super.dispose();
  }

  Future<void> _showTimeoutDialog() async {
    if (_isTimeoutDialogVisible || !mounted) return;
    _isTimeoutDialogVisible = true;
    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => TimeoutDialog(
          onGotIt: () {
            Navigator.of(dialogContext).pop();
            _goHome();
          },
        ),
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

  Future<void> _onPayNow(BookingProvider provider) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesi telah habis, silakan login ulang!')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppConstants.primaryColor),
        ),
      );

      await provider.processPayment(
        bookingId: provider.currentBookingId!, // Ambil ID yang didapat dari lockSeats
        paymentMethod: provider.selectedPayment,
        token: token,
      );

      if (!mounted) return;
      Navigator.pop(context); // tutup loading

      final Booking finalBooking = provider.completePayment();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SuccessScreen(booking: finalBooking)),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // tutup loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memproses pembayaran: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);

    if (provider.activeMovie == null) {
      return const Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: Center(child: Text('No active booking')),
      );
    }

    final isWide = MediaQuery.of(context).size.width > 900;

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
              physics: kIsWeb
                  ? const ClampingScrollPhysics()
                  : const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? AppConstants.padding : 16.0,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isWide
                      ? _buildDesktopLayout(provider)
                      : _buildMobileLayout(provider),
                  const SizedBox(height: 32),
                  _buildPayButton(isWide, provider),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BookingProvider provider,
      {required double posterHeight, required double posterWidth}) {
    return OrderSummaryCard(
      movie: provider.activeMovie!,
      cinema: provider.selectedCinema,
      date: provider.selectedDate,
      time: provider.selectedTime,
      seats: provider.selectedSeats.map((s) => s.seatNumber).toList(),
      totalPrice: provider.totalPrice.toDouble(),
      posterHeight: posterHeight,
      posterWidth: posterWidth,
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
              Expanded(
                flex: 5,
                child: PaymentMethodsCard(
                  selectedPayment: provider.selectedPayment,
                  onMethodSelected: provider.selectPaymentMethod,
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(top: 42),
                  child: _buildOrderSummary(provider,
                      posterHeight: 280, posterWidth: 180),
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
        _buildOrderSummary(provider, posterHeight: 170, posterWidth: 120),
        const SizedBox(height: 28),
        PaymentMethodsCard(
          selectedPayment: provider.selectedPayment,
          onMethodSelected: provider.selectPaymentMethod,
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
            disabledBackgroundColor:
                AppConstants.primaryColor.withOpacity(0.45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          onPressed: provider.canPay ? () => _onPayNow(provider) : null,
          child: Text(
            provider.canPay
                ? 'Pay Now · Rp ${provider.totalPrice}'
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