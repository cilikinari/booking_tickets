import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../data/datasources/auth_services.dart';

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

  String _getImageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;

    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    
    final baseUrl = AuthServices.baseUrl.replaceAll('/api/v1', '');

    return '$baseUrl/$cleanPath';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              _getImageUrl(movie.posterUrl),
              width: posterWidth,
              height: posterHeight,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: posterWidth,
                  height: posterHeight,
                  color: AppConstants.inputColor,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white54),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: posterWidth,
                  height: posterHeight,
                  color: AppConstants.inputColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.movie_filter_outlined,
                        color: Colors.white24,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'No Poster',
                        style: TextStyle(color: Colors.white24, fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppConstants.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  movie.genres.isNotEmpty
                      ? movie.genres.map((g) => g.name).join(', ')
                      : 'No Genre',
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
        'Rp ${AppHelpers.formatNumber(totalPrice)}',
        style: const TextStyle(
          color: AppConstants.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}