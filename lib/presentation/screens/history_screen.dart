import 'package:flutter/foundation.dart'; // 🟢 TAMBAHAN WAJIB UNTUK DETEKSI WEB
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/booking.dart';
import '../../data/models/movie.dart';
import '../../domain/providers/history_provider.dart';
import '../../domain/providers/movie_provider.dart';
import '../widgets/bottom_nav.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Movie? _getMovieByTitle(String title, MovieProvider movieProvider) {
    try {
      // 🟢 Pastikan menyisir variabel topMovies dan nowPlaying yang baru dari API
      final allMovies = [
        ...movieProvider.topMovies,
        ...movieProvider.nowPlaying,
      ];
      return allMovies.firstWhere((movie) => movie.title == title);
    } catch (e) {
      return null;
    }
  }

  // 🟢 FUNGSI HELPER BARU: Deteksi URL otomatis biar gak nge-hang di Web/Emulator
  String _getImageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;

    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';

    return '$baseUrl/$cleanPath';
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final movieProvider = Provider.of<MovieProvider>(context);

    final bookings = historyProvider.bookingHistory;

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth > 900;
    final double horizontalPadding = isWide ? AppConstants.padding : 16.0;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
              break;
            case 1:
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
              break;
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: BackButton(color: Colors.white),
                  ),
                  const Text(
                    'History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: bookings.isEmpty
                  ? Center(
                      child: Text(
                        'No booking history',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 16,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 16,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: AppConstants.maxWidth,
                          ),
                          child: Column(
                            children: [
                              ...bookings.map((booking) {
                                final movie = _getMovieByTitle(
                                  booking.movieTitle,
                                  movieProvider,
                                );
                                return _buildBookingCard(
                                  booking,
                                  movie,
                                  isWide,
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking, Movie? movie, bool isWide) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: isWide
          ? _buildWideLayout(booking, movie)
          : _buildMobileLayout(booking, movie),
    );
  }

  Widget _buildWideLayout(Booking booking, Movie? movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPoster(movie, 120, 160),
            const SizedBox(width: 24),
            Expanded(child: _buildMovieInfo(booking, movie)),
          ],
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.bottomRight,
          child: _buildActionButton(booking),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(Booking booking, Movie? movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPoster(movie, 100, 140),
            const SizedBox(width: 16),
            Expanded(child: _buildMovieInfo(booking, movie)),
          ],
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.bottomRight,
          child: _buildActionButton(booking),
        ),
      ],
    );
  }

  Widget _buildPoster(Movie? movie, double w, double h) {
    if (movie != null && movie.posterUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          // 🟢 GUNAKAN HELPER _getImageUrl DI SINI
          _getImageUrl(movie.posterUrl),
          width: w,
          height: h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: w,
              height: h,
              color: Colors.white.withOpacity(0.1),
              child: const Icon(Icons.broken_image, color: Colors.grey),
            );
          },
        ),
      );
    }
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.movie, color: Colors.grey),
    );
  }

  Widget _buildMovieInfo(Booking booking, Movie? movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          booking.movieTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (movie != null) ...[
          const SizedBox(height: 4),
          Text(
            movie.genres.map((g) => g.name).join(', '),
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ],
        const SizedBox(height: 12),
        _infoRow('Cinema:', booking.cinema),
        _infoRow('Date:', booking.date),
        _infoRow('Time:', booking.time),
        _infoRow('Seats:', booking.seats.join(', ')),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Rp ${AppHelpers.formatNumber(booking.totalPrice)}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Booking booking) {
    return Text(
      booking.status,
      style: const TextStyle(
        color: Colors.lightBlue,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
