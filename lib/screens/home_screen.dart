import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../data/movie_data.dart';
import '../data/city_data.dart';
import '../utils/constants.dart';
import 'detail_screen.dart';
import 'search_screen.dart';
import 'history_screen.dart';
import 'profile.screen.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCity = "Choose City";
  final TextEditingController _citySearchController = TextEditingController();

  static const TextStyle _brandTextStyle = TextStyle(
    color: AppConstants.primaryColor,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.italic,
    letterSpacing: 0.6,
  );

  static const TextStyle _brandPlusTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.italic,
    letterSpacing: 0.6,
  );

  @override
  void dispose() {
    _citySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
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
                  const Text(
                    "Top Movies",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _MovieSection(movies: MovieData.topMovies, isWide: true),
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
                  _MovieSection(movies: MovieData.nowPlaying, isWide: false),
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
            Icon(Icons.email, color: Colors.grey, size: 20),
          ],
        ),
      ],
    );
  }

  void _openCityPicker() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          builder: (context, setPopupState) {
            final filteredCities = CityData.cities
                .where(
                  (city) => city.toLowerCase().contains(
                    _citySearchController.text.toLowerCase(),
                  ),
                )
                .toList();

            return Stack(
              children: [
                Positioned(
                  top: 80,
                  right: 16,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 320,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.cardColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                            child: Text(
                              "Select your location",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: _citySearchController,
                                      onChanged: (_) => setPopupState(() {}),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: "Search city",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  if (_citySearchController.text.isNotEmpty)
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        _citySearchController.clear();
                                        setPopupState(() {});
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Flexible(
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 12),
                              itemCount: filteredCities.length,
                              separatorBuilder: (context, index) => Divider(
                                color: Colors.white.withOpacity(0.05),
                                height: 1,
                                indent: 20,
                                endIndent: 20,
                              ),
                              itemBuilder: (context, index) {
                                final city = filteredCities[index];
                                final selected = city == _selectedCity;
                                return ListTile(
                                  leading: Icon(
                                    Icons.location_on,
                                    color: selected
                                        ? AppConstants.primaryColor
                                        : Colors.grey,
                                    size: 18,
                                  ),
                                  title: Text(
                                    city.toUpperCase(),
                                    style: TextStyle(
                                      color: selected
                                          ? AppConstants.primaryColor
                                          : Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  dense: true,
                                  onTap: () {
                                    setState(() => _selectedCity = city);
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
                ),
              ],
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
        const _BrandLogo(),
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

class _MovieSection extends StatelessWidget {
  final List<Movie> movies;
  final bool isWide;

  const _MovieSection({required this.movies, required this.isWide});

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

class _BrandLogo extends StatelessWidget {
  const _BrandLogo();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('CINEMA', style: _HomeScreenState._brandTextStyle),
        Text('+', style: _HomeScreenState._brandPlusTextStyle),
      ],
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
