import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../data/movie_data.dart';
import '../data/city_data.dart';
import '../icons/app_icons.dart';
import '../utils/constants.dart';
import 'detail_screen.dart';
import 'search_screen.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCity = "Bali";
  final TextEditingController _citySearchController = TextEditingController();

  @override
  void dispose() {
    _citySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      bottomNavigationBar: CustomBottomNav(currentIndex: 0, onTap: (index) {}),
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
                  const Text(
                    "Top Movies",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _MovieSection(
                    title: "Top Movies",
                    movies: MovieData.topMovies,
                    isWide: true,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Now Showing",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _MovieSection(
                    title: "Now Showing",
                    movies: MovieData.nowPlaying,
                    isWide: false,
                  ),
                  const SizedBox(height: 80), // Larger gap from Now Showing
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
            Icon(Icons.language, color: Colors.grey, size: 20),
          ],
        ),
      ],
    );
  }

  void _openCityPicker() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setPopupState) {
            final filteredCities = CityData.cities
                .where(
                  (city) => city.toLowerCase().contains(
                    _citySearchController.text.toLowerCase(),
                  ),
                )
                .toList();

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 300,
                  height: 360,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppConstants.cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select your location",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Icon(AppIcons.search, color: Colors.grey, size: 17),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextField(
                                controller: _citySearchController,
                                onChanged: (_) => setPopupState(() {}),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: 'Search city',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.7),
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            if (_citySearchController.text.isNotEmpty)
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(
                                  AppIcons.clear,
                                  color: Colors.grey,
                                  size: 17,
                                ),
                                onPressed: () {
                                  _citySearchController.clear();
                                  setPopupState(() {});
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: filteredCities.length,
                          separatorBuilder: (_, __) =>
                              const Divider(color: Colors.white12, height: 1),
                          itemBuilder: (context, index) {
                            final city = filteredCities[index];
                            final bool selected = city == _selectedCity;

                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                AppIcons.location,
                                size: 17,
                                color: selected ? Colors.red : Colors.white70,
                              ),
                              title: Text(
                                city.toUpperCase(),
                                style: TextStyle(
                                  color: selected ? Colors.red : Colors.white,
                                  fontSize: 12,
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                ),
                              ),
                              trailing: selected
                                  ? const Icon(
                                      AppIcons.check,
                                      color: Colors.red,
                                      size: 17,
                                    )
                                  : null,
                              onTap: () {
                                setState(() {
                                  _selectedCity = city;
                                });
                                _citySearchController.clear();
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: _openCityPicker,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppConstants.primaryColor),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Row(
              children: [
                Text(
                  _selectedCity,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.black),
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

class _MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final bool isWide;

  const _MovieSection({
    required this.title,
    required this.movies,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: movies.map((movie) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _MovieCard(movie: movie, isWide: isWide),
          );
        }).toList(),
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isWide;

  const _MovieCard({required this.movie, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(movie: movie)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              movie.imagePath,
              fit: BoxFit.cover,
              height: isWide ? 200 : 220,
              width: isWide ? 350 : 150,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: isWide ? 350 : 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Container(
                    constraints: BoxConstraints(minHeight: isWide ? 40 : 35),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      movie.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isWide ? 20 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${isWide ? '2025' : '2026'} • ${movie.genre}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
