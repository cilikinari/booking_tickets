import 'package:flutter/material.dart';
import '../../data/movie_data.dart';
import '../../utils/constants.dart';
import '../widgets/movie_section.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_footer.dart'; // <-- Import AppFooter
import 'login_screen.dart';
import 'register.dart';

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

                  // Section Top Movies
                  MovieSection(
                    title: "Top Movies",
                    movies: MovieData.topMovies,
                    isWide: true,
                    onMovieTap: null,
                  ),

                  const SizedBox(height: 24),

                  // Section Now Showing
                  MovieSection(
                    title: "Now Showing",
                    movies: MovieData.nowPlaying,
                    isWide: false,
                    onMovieTap: null,
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppLogo(),
        Row(
          children: [
            // Tombol Sign In (Gaya Outlined Text)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: AppConstants.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Tombol Sign Up (Gaya Utama)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text(
                'Sign Up',
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
