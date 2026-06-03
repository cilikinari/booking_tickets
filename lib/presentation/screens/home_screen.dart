import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/movie.dart';
import '../../domain/providers/movie_provider.dart';
import '../../domain/providers/location_provider.dart'; // 🟢 Tambahkan import LocationProvider
import '../../utils/constants.dart';
import 'detail_screen.dart';
import 'search_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/movie_section.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_footer.dart';
import '../widgets/city_picker.dart';

// 🟢 Diubah menjadi StatelessWidget karena tidak ada State lokal lagi
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🟢 Mengambil data film dan lokasi dari Provider pusat
    final movieProvider = Provider.of<MovieProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
        onTap: (index) =>
            _onBottomNavTap(context, index), // 🟢 Dipisah ke fungsi helper
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(
                    context,
                    locationProvider,
                  ), // 🟢 Oper provider lokasi ke header
                  const SizedBox(height: 16),
                  _buildSearchBar(context),
                  const SizedBox(height: 24),

                  // Section Top Movies
                  MovieSection(
                    title: "Top Movies",
                    movies: movieProvider.topMovies,
                    isWide: true,
                    onMovieTap: (movie) => _navigateToDetail(context, movie),
                  ),

                  const SizedBox(height: 24),

                  // Section Now Showing
                  MovieSection(
                    title: "Now Showing",
                    movies: movieProvider.nowPlaying,
                    isWide: false,
                    onMovieTap: (movie) => _navigateToDetail(context, movie),
                  ),

                  const SizedBox(height: 80),
                  const AppFooter(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🟢 Helper untuk navigasi menu bawah
  void _onBottomNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HistoryScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
    }
  }

  void _navigateToDetail(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(movie: movie)),
    );
  }

  // 🟢 Terima parameter locationProvider
  Widget _buildHeader(BuildContext context, LocationProvider locationProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppLogo(),
        _buildCitySelector(context, locationProvider),
      ],
    );
  }

  // 🟢 Logika showDialog disederhanakan tanpa perlu menangkap variabel return manual
  Widget _buildCitySelector(
    BuildContext context,
    LocationProvider locationProvider,
  ) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) =>
              CityPickerDialog(), // Constructor bersih tanpa kirim parameter manual
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppConstants.cardColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on,
              color: AppConstants.primaryColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              // 🟢 Menampilkan data langsung dari state global lokasi
              locationProvider.selectedCity,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              color: AppConstants.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SearchScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppConstants.cardColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: AppConstants.textMuted),
            SizedBox(width: 8),
            Text(
              "Search for movies or genres",
              style: TextStyle(color: AppConstants.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
