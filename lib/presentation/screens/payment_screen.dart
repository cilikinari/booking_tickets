import 'dart:async'; // Untuk StreamSubscription
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/booking_provider.dart';
import '../../domain/providers/auth_provider.dart';
import '../../data/datasources/websocket_service.dart';
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
  bool _isProcessingPayment =
      false; // 🔥 State untuk mengatur loading di tombol

  BookingProvider? _bookingProvider;

  // WebSocket Service & Subscription
  final WebSocketService _webSocketService = WebSocketService();
  StreamSubscription? _wsSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initBookingLock();
    });
  }

  Future<void> _initBookingLock() async {
    _bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppConstants.primaryColor),
      ),
    );

    try {
      await _bookingProvider!.lockSeats(token);

      if (!mounted) return;
      Navigator.pop(context); // Tutup loading dialog lock seats

      // 🔥 Aktifkan WebSocket setelah kursi berhasil dikunci
      _initWebSocket(authProvider.currentUserId);

      _bookingProvider!.startPaymentTimer(_showTimeoutDialog);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Tutup loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }

  // 🔥 Fungsi mendengarkan sinyal WebSocket secara real-time
  void _initWebSocket(String? userId) {
    if (userId == null) return;

    // ✅ Terhubung ke server (Tanpa melemparkan BuildContext lagi)
    _webSocketService.connectToServer(userId);

    // Listen ke aliran data (stream)
    _wsSubscription = _webSocketService.paymentStream.listen((data) {
      final String status = data['status'] ?? '';
      final String message = data['message'] ?? 'Notification';

      if (!mounted) return;

      // 1. Munculkan snackbar notifikasi dari server
      _showFloatingNotification(context, message, status);

      // 2. Jika status 'success' (misal dibayar lewat kanal luar), langsung trigger sukses
      if (status == 'success') {
        _handlePaymentSuccess();
      }
    });
  }

  // Fungsi helper ketika pembayaran sukses (dipakai di WS atau tombol HTTP)
  void _handlePaymentSuccess() {
    if (_bookingProvider == null) return;

    _bookingProvider!.stopTimer(); // Matikan countdown timer
    final Booking finalBooking = _bookingProvider!.completePayment();

    // Arahkan langsung ke Success Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => SuccessScreen(booking: finalBooking)),
    );
  }

  // Fungsi pembantu untuk memunculkan SnackBar mengambang yang rapi
  void _showFloatingNotification(
    BuildContext context,
    String message,
    String status,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              status == 'success' ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: status == 'success'
            ? Colors.green.shade700
            : Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  void dispose() {
    // 🛑 Bersihkan semua subscription & koneksi demi mencegah memory leak
    _wsSubscription?.cancel();
    _webSocketService.disconnect();
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

    // 1. Set tombol ke mode loading
    setState(() {
      _isProcessingPayment = true;
    });

    try {
      // 💡 JEDA BUATAN (1.5 Detik): Memberikan efek loading transisi yang mulus di server lokal
      await Future.delayed(const Duration(milliseconds: 1500));

      await provider.processPayment(
        bookingId: provider.currentBookingId!,
        paymentMethod: provider.selectedPayment,
        token: token,
      );

      if (!mounted) return;

      // Jika sukses, lempar ke halaman sukses
      _handlePaymentSuccess();
    } catch (e) {
      if (!mounted) return;

      // 2. Jika gagal, matikan loading agar user bisa klik ulang tombolnya
      setState(() {
        _isProcessingPayment = false;
      });

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

  Widget _buildOrderSummary(
    BookingProvider provider, {
    required double posterHeight,
    required double posterWidth,
  }) {
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
                  child: _buildOrderSummary(
                    provider,
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
            disabledBackgroundColor: AppConstants.primaryColor.withOpacity(
              0.45,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          // ✅ Mengunci tombol agar tidak bisa di-spam klik selama proses loading berjalan
          onPressed: (provider.canPay && !_isProcessingPayment)
              ? () => _onPayNow(provider)
              : null,
          child: _isProcessingPayment
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
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
