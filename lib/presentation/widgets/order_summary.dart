import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class OrderSummaryCard extends StatelessWidget {
  final Movie movie;
  final String cinema;
  final String date;
  final String time;
  final List<String> seats;
  final double totalPrice;
  final double posterHeight;
  final double posterWidth;

  const OrderSummaryCard({
    super.key,
    required this.movie,
    required this.cinema,
    required this.date,
    required this.time,
    required this.seats,
    required this.totalPrice,
    required this.posterHeight,
    required this.posterWidth,
  });

  String get _formattedSeats => seats.join(', ');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              movie.posterUrl,
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
                  movie.title,
                  style: const TextStyle(
                    color: AppConstants.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  movie.genres.isNotEmpty ? movie.genres.map((g) => g.name).join(', ') : 'No Genre',
                  style: const TextStyle(
                    color: AppConstants.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Cinema:', cinema),
                _buildInfoRow('Date:', date),
                _buildInfoRow('Time:', time),
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
            style: const TextStyle(color: AppConstants.textMuted, fontSize: 12),
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
        'Rp ${AppHelpers.formatNumber(totalPrice)}', // Menggunakan format global
        style: const TextStyle(
          color: AppConstants.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
