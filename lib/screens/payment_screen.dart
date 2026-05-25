import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/booking.dart';
import '../utils/constants.dart';
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
  static const _countdownSeconds = 10 * 60;
  static const _paymentMethods = ['OVO', 'Dana', 'Gopay', 'LinkAja', 'Shopeepay'];

  String _selectedPayment = '';
  int _remainingSeconds = _countdownSeconds;
  Timer? _timer;

  // ── LIFECYCLE ──────────────────────────────────────────────

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

  // ── LOGIC ──────────────────────────────────────────────────

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 0) {
        _timer?.cancel();
        if (mounted) Navigator.pop(context);
        return;
      }
      setState(() => _remainingSeconds--);
    });
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

  // ── GETTERS ────────────────────────────────────────────────

  bool get _canPay => _selectedPayment.isNotEmpty;

  String get _formattedSeats => widget.seats.join(', ');

  String get _formattedCountdown {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _formattedPrice =>
      'Rp${widget.totalPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.')}';

  ScrollPhysics get _scrollPhysics =>
      kIsWeb ? const ClampingScrollPhysics() : const BouncingScrollPhysics();

  // ── BUILD ──────────────────────────────────────────────────

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
            fontSize: 18,
          ),
        ),
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

  // ── LAYOUTS ────────────────────────────────────────────────

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCountdownBanner(),
        const SizedBox(height: 32),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildPaymentMethodsCard()),
              const SizedBox(width: 48),
              SizedBox(
                width: 460,
                child: Padding(
                  padding: const EdgeInsets.only(top: 42), // align with card below "Payment Methods" title + spacing
                  child: _buildOrderSummaryCard(posterHeight: 320, posterWidth: 200),
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
        _buildCountdownBanner(),
        const SizedBox(height: 20),
        _buildOrderSummaryCard(posterHeight: 170, posterWidth: 120),
        const SizedBox(height: 28),
        _buildPaymentMethodsCard(),
      ],
    );
  }

  // ── WIDGETS ────────────────────────────────────────────────

  Widget _buildCountdownBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Yuk, selesaikan pembayaranmu dalam',
              style: const TextStyle(
                color: Color(0xFF9B2630),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              _formattedCountdown,
              style: const TextStyle(
                color: Color(0xFF9B2630),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard({
    required double posterHeight,
    required double posterWidth,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              widget.movie.imagePath,
              width: posterWidth,
              height: posterHeight,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movie.title,
                  style: const TextStyle(
                    color: AppConstants.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.movie.genre,
                  style: const TextStyle(
                    color: AppConstants.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Cinema:', widget.cinema),
                _buildInfoRow('Date:', widget.date),
                _buildInfoRow('Time:', widget.time),
                _buildInfoRow('Seats:', _formattedSeats),
                const SizedBox(height: 12),
                _buildPriceBadge(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              color: AppConstants.textMuted,
              fontSize: 12,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: AppConstants.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppConstants.inputColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _formattedPrice,
        style: const TextStyle(
          color: AppConstants.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Methods',
          style: TextStyle(
            color: AppConstants.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: AppConstants.cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: _paymentMethods
                .map((method) => _buildPaymentTile(method))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTile(String method) {
    final isSelected = _selectedPayment == method;
    return ListTile(
      onTap: () => setState(() => _selectedPayment = method),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      title: Text(
        method,
        style: const TextStyle(
          color: AppConstants.textPrimary,
          fontSize: 15,
        ),
      ),
      trailing: _RadioIndicator(isSelected: isSelected),
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
            disabledBackgroundColor:
                AppConstants.primaryColor.withValues(alpha: 0.45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          onPressed: _canPay ? _onPayNow : null,
          child: Text(
            _canPay ? 'Pay Now · $_formattedPrice' : 'Select Payment Method',
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

// ── EXTRACTED WIDGET ───────────────────────────────────────────────────────────

/// Radio-style selection indicator: white ring with a filled blue dot when selected.
class _RadioIndicator extends StatelessWidget {
  final bool isSelected;

  const _RadioIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      height: 26,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}