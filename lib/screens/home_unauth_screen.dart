import 'package:flutter/material.dart';
import '../data/movie_data.dart';
import '../utils/constants.dart';
import '../widgets/movie_section.dart';
import '../widgets/app_logo.dart'; // <-- Import AppLogo
import 'login_screen.dart';

class HomeUnauthScreen extends StatelessWidget {
  const HomeUnauthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),

                  // Section Top Movies (Judul dikirim lewat parameter widget)
                  MovieSection(
                    title: "Top Movies",
                    movies: MovieData.topMovies,
                    isWide: true,
                    onMovieTap: null,
                  ),

                  const SizedBox(height: 24),

                  // Section Now Showing (Judul dikirim lewat parameter widget)
                  MovieSection(
                    title: "Now Showing",
                    movies: MovieData.nowPlaying,
                    isWide: false,
                    onMovieTap: null,
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppLogo(), // <-- Panggil widget AppLogo di sini
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
