import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/movie.dart';
import '../../domain/providers/movie_provider.dart';
import '../../domain/providers/location_provider.dart'; 
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

// 1. 🟢 DIUBAH JADI STATEFULWIDGET: Supaya bisa nembak API pas halaman diakses
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 2. 🟢 PEMICU API: Ambil data film teranyar dari backend Go-Fiber
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).fetchHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listener untuk lokasi tetap di root build method
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
        onTap: (index) => _onBottomNavTap(context, index), 
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.padding),
              // 3. 🟢 BUNGKUS DENGAN CONSUMER: Menangani state loading/error film secara reaktif
              child: Consumer<MovieProvider>(
                builder: (context, movieProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, locationProvider), 
                      const SizedBox(height: 16),
                      _buildSearchBar(context),
                      const SizedBox(height: 24),

                      // =========================================================
                      // KONDISI 1: JIKA SEAT / FILM SEDANG DI-DOWNLOAD
                      // =========================================================
                      if (movieProvider.isLoading)
                        const SizedBox(
                          height: 350,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
                            ),
                          ),
                        )

                      // =========================================================
                      // KONDISI 2: JIKA BACKEND GO-FIBER DOWN / OFFLINE
                      // =========================================================
                      else if (movieProvider.errorMessage.isNotEmpty)
                        SizedBox(
                          height: 350,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.cloud_off, size: 60, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  movieProvider.errorMessage,
                                  style: const TextStyle(color: Colors.red, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppConstants.primaryColor),
                                  onPressed: () => movieProvider.fetchHomeData(),
                                  child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        )

                      // =========================================================
                      // KONDISI 3: BERHASIL AMBIL DATA DARI BACKEND
                      // =========================================================
                      else ...[
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
                      ],

                      const SizedBox(height: 80),
                      const AppFooter(),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _buildHeader(BuildContext context, LocationProvider locationProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppLogo(),
        _buildCitySelector(context, locationProvider),
      ],
    );
  }

  Widget _buildCitySelector(BuildContext context, LocationProvider locationProvider) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => CityPickerDialog(), 
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