import 'package:flutter/material.dart';
import '../../data/movie_data.dart';
import '../../utils/constants.dart';
import 'detail_screen.dart';
import 'search_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/movie_section.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_footer.dart'; // <-- Tambahkan import ini
import '../widgets/city_picker.dart';
import '../../data/city_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCity = 'Choose City'; // Jakarta as default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
        onTap: (index) {
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
        },
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
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildSearchBar(context),
                  const SizedBox(height: 24),

                  // Section Top Movies
                  MovieSection(
                    title: "Top Movies",
                    movies: MovieData.topMovies,
                    isWide: true,
                    onMovieTap: (movie) => _navigateToDetail(movie),
                  ),

                  const SizedBox(height: 24),

                  // Section Now Showing
                  MovieSection(
                    title: "Now Showing",
                    movies: MovieData.nowPlaying,
                    isWide: false,
                    onMovieTap: (movie) => _navigateToDetail(movie),
                  ),

                  const SizedBox(height: 80),

                  // Panggil widget AppFooter di sini
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

  void _navigateToDetail(dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(movie: movie)),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [const AppLogo(), _buildCitySelector()],
    );
  }

  Widget _buildCitySelector() {
    return GestureDetector(
      onTap: () async {
        final result = await showDialog<String>(
          context: context,
          builder: (_) => CityPickerDialog(currentCity: selectedCity),
        );
        if (result != null) {
          setState(() {
            selectedCity = result;
          });
        }
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
              selectedCity,
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
