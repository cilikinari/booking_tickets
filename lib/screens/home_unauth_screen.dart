import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../data/movie_data.dart';
import '../utils/constants.dart';
// Pastikan import ini mengarah ke file Sign In buatanmu
import 'login_screen.dart';

class HomeUnauthScreen extends StatelessWidget {
  const HomeUnauthScreen({super.key});

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      // BottomNavigationBar DIHAPUS karena user belum login
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
                  ), // Lempar context untuk navigasi Sign In

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

  // --- BAGIAN FOOTER ---
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

  // --- BAGIAN HEADER (LOGO + TOMBOL SIGN IN/UP) ---
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo Cinema+
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('CINEMA', style: _brandTextStyle),
            Text('+', style: _brandPlusTextStyle),
          ],
        ),
        // Mengganti tombol City dengan Sign In & Sign Up
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              onPressed: () {
                // Arahkan ke halaman Sign In saat diklik
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// --- BAGIAN LIST FILM ---
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

// --- BAGIAN KARTU FILM (Kini tidak bisa diklik) ---
class _MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isWide;

  const _MovieCard({required this.movie, required this.isWide});

  @override
  Widget build(BuildContext context) {
    // GestureDetector DIHAPUS agar tidak pindah ke halaman DetailScreen
    return Column(
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
    );
  }
}
