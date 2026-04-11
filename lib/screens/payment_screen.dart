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
  String _selectedPayment = 'OVO';

  final List<String> _paymentMethods = [
    'OVO',
    'Dana',
    'Gopay',
    'LinkAja',
    'Shopeepay',
  ];

  String get _formattedSeats => widget.seats.join(', ');

  String _formatPrice(double price) {
    return price
        .toInt()
        .toString()
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');
  }

  void _onPayNow() {
    // Buat object Booking
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
      MaterialPageRoute(
        builder: (_) => SuccessScreen(booking: booking),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderSummary(),
                  const SizedBox(height: 28),
                  _buildPaymentMethods(),
                ],
              ),
            ),
          ),
          _buildPayButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              widget.movie.imagePath,
              width: 90,
              height: 130,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movie.title,
                  style: const TextStyle(
                    color: AppConstants.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.movie.genre,
                  style: const TextStyle(
                    color: AppConstants.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                _infoRow('Cinema:', widget.cinema, bold: true),
                _infoRow('Date:', widget.date, bold: true),
                _infoRow('Time:', widget.time, bold: true),
                _infoRow('Seats:', _formattedSeats, bold: true),
                const SizedBox(height: 12),
                // Price badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppConstants.inputColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${AppConstants.defaultCurrency}${_formatPrice(widget.totalPrice)}',
                    style: const TextStyle(
                      color: AppConstants.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool bold = false}) {
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
              style: TextStyle(
                color: AppConstants.textPrimary,
                fontSize: 12,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
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
          decoration: BoxDecoration(
            // color: AppConstants.cardColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Column(
            children: _paymentMethods.map((method) {
              final isSelected = _selectedPayment == method;

              return Column(
                children: [
                  ListTile(
                    onTap: () => setState(() => _selectedPayment = method),
                    title: Text(
                      method,
                      style: const TextStyle(
                        color: AppConstants.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                    trailing: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Colors.lightBlue
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? Colors.lightBlue
                              : Colors.white30,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          onPressed: _onPayNow,
          child: const Text(
            'Pay Now',
            style: TextStyle(
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