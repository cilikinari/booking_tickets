import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/models/booking.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart'; // Import helper global
import '../widgets/countdown_banner.dart';
import '../widgets/order_summary.dart';
import '../widgets/payment_method.dart';
import '../widgets/timeout_dialog.dart';
import 'home_screen.dart';
import 'success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Movie movie;
  final String cinema;
  final String date;
  final String time;
  final List<String> seats;
  final double totalPrice;

  const PaymentScreen({
    super.key,
    required this.movie,
    required this.cinema,
    required this.date,
    required this.time,
    required this.seats,
    required this.totalPrice,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const _countdownSeconds = 10 * 10;

  String _selectedPayment = '';
  int _remainingSeconds = _countdownSeconds;
  Timer? _timer;
  bool _isTimeoutDialogVisible = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      if (_remainingSeconds <= 1) {
        setState(() => _remainingSeconds = 0);
        _timer?.cancel();
        _showTimeoutDialog();
        return;
      }

      setState(() => _remainingSeconds--);
    });
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

  void _onPayNow() {
    if (!_canPay) return;
    _timer?.cancel();

    final booking = Booking(
      movieTitle: widget.movie.title,
      cinema: widget.cinema,
      date: widget.date,
      time: widget.time,
      seats: widget.seats,
      totalPrice: widget.totalPrice,
      status: 'upcoming',
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => SuccessScreen(booking: booking)),
    );
  }

  bool get _canPay => _selectedPayment.isNotEmpty;

  String get _formattedCountdown {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  ScrollPhysics get _scrollPhysics =>
      kIsWeb ? const ClampingScrollPhysics() : const BouncingScrollPhysics();

  @override
  Widget build(BuildContext context) {
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
                  isWide ? _buildDesktopLayout() : _buildMobileLayout(),
                  const SizedBox(height: 32),
                  _buildPayButton(isWide),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CountdownBanner(formattedCountdown: _formattedCountdown),
        const SizedBox(height: 32),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PaymentMethodsCard(
                  selectedPayment: _selectedPayment,
                  onMethodSelected: (method) =>
                      setState(() => _selectedPayment = method),
                ),
              ),
              const SizedBox(width: 48),
              SizedBox(
                width: 460,
                child: Padding(
                  padding: const EdgeInsets.only(top: 42),
                  child: OrderSummaryCard(
                    movie: widget.movie,
                    cinema: widget.cinema,
                    date: widget.date,
                    time: widget.time,
                    seats: widget.seats,
                    totalPrice: widget.totalPrice,
                    posterHeight: 320,
                    posterWidth: 200,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CountdownBanner(formattedCountdown: _formattedCountdown),
        const SizedBox(height: 20),
        OrderSummaryCard(
          movie: widget.movie,
          cinema: widget.cinema,
          date: widget.date,
          time: widget.time,
          seats: widget.seats,
          totalPrice: widget.totalPrice,
          posterHeight: 170,
          posterWidth: 120,
        ),
        const SizedBox(height: 28),
        PaymentMethodsCard(
          selectedPayment: _selectedPayment,
          onMethodSelected: (method) =>
              setState(() => _selectedPayment = method),
        ),
      ],
    );
  }

  Widget _buildPayButton(bool isWide) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 28, bottom: 20),
        width: isWide ? 360 : double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            disabledBackgroundColor: AppConstants.primaryColor.withValues(
              alpha: 0.45,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          onPressed: _canPay ? _onPayNow : null,
          child: Text(
            _canPay 
                ? 'Pay Now · ${AppConstants.defaultCurrency}${AppHelpers.formatNumber(widget.totalPrice)}' 
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