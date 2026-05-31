import 'package:flutter/material.dart';
import '../data/movie_data.dart';
import '../utils/constants.dart';
import 'detail_screen.dart';
import 'search_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/movie_section.dart';
import '../widgets/app_logo.dart';
import '../widgets/city_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCity = "Choose City";

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

                  // Section Top Movies (Judul dikirim lewat parameter widget)
                  MovieSection(
                    title: "Top Movies",
                    movies: MovieData.topMovies,
                    isWide: true,
                    onMovieTap: (movie) => _navigateToDetail(movie),
                  ),

                  const SizedBox(height: 24),

                  // Section Now Showing (Judul dikirim lewat parameter widget)
                  MovieSection(
                    title: "Now Showing",
                    movies: MovieData.nowPlaying,
                    isWide: false,
                    onMovieTap: (movie) => _navigateToDetail(movie),
                  ),

                  const SizedBox(height: 80),
                  _buildFooter(),
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

  Widget _buildFooter() {
    return const Column(
      children: [
        Text(
          "Enjoy the best movie experience with our seamless ticket booking system. Explore the latest releases and secure your seats in just a few clicks.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.5),
        ),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.discord, color: Colors.grey, size: 20),
            SizedBox(width: 20),
            Icon(Icons.telegram, color: Colors.grey, size: 20),
            SizedBox(width: 20),
            Icon(Icons.email, color: Colors.grey, size: 20),
          ],
        ),
      ],
    );
  }

  Future<void> _openCityPicker() async {
    final selected = await showGeneralDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, anim1, anim2) {
        return CityPickerDialog(currentCity: _selectedCity);
      },
    );

    if (selected != null && selected != _selectedCity) {
      setState(() => _selectedCity = selected);
    }
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppLogo(),
        _CitySelectorButton(
          selectedCity: _selectedCity,
          onTap: _openCityPicker,
        ),
      ],
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

class _CitySelectorButton extends StatelessWidget {
  final String selectedCity;
  final VoidCallback onTap;

  const _CitySelectorButton({required this.selectedCity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(21),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF222222),
          borderRadius: BorderRadius.circular(19),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on_rounded,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                selectedCity.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
