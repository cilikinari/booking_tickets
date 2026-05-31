import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../models/movie.dart';
import '../widgets/bottom_nav.dart';
import '../utils/constants.dart';
import '../data/movie_data.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final List<Booking> bookings;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
  }

  void _initializeMockData() {
    bookings = [
      Booking(
        movieTitle: MovieData.topMovies[0].title,
        cinema: 'XXI Living World',
        date: '19 Apr 2026',
        time: '17:30 PM',
        seats: ['F1', 'F2'],
        totalPrice: 120000,
        status: 'Berhasil',
      ),
      Booking(
        movieTitle: MovieData.topMovies[1].title,
        cinema: 'XXI Living World',
        date: '30 March 2026',
        time: '17:30 PM',
        seats: ['B1', 'B2'],
        totalPrice: 120000,
        status: 'Berhasil',
      ),
    ];
  }

  Movie? _getMovieByTitle(String title) {
    try {
      return MovieData.topMovies.firstWhere((movie) => movie.title == title);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // Already on history
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
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Mengganti Container bulatan lama dengan BackButton bawaan Flutter
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const BackButton(color: Colors.white),
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
            // Booking list
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
            // Poster
            if (movie != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  movie.imagePath,
                  width: 120,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            const SizedBox(width: 24),
            // Movie info
            Expanded(child: _buildMovieInfo(booking, movie)),
          ],
        ),
        const SizedBox(height: 16),
        // Action button at bottom right
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
            // Poster
            if (movie != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  movie.imagePath,
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: 100,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            const SizedBox(width: 16),
            // Movie info
            Expanded(child: _buildMovieInfo(booking, movie)),
          ],
        ),
        const SizedBox(height: 16),
        // Action button at bottom right
        Align(
          alignment: Alignment.bottomRight,
          child: _buildActionButton(booking),
        ),
      ],
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
            movie.genre,
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
            'Rp${booking.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.')}',
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
