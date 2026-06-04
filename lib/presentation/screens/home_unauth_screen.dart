import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/movie_provider.dart';
import '../../utils/constants.dart';
import '../widgets/movie_section.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_footer.dart';
import 'login_screen.dart';
import 'register.dart';

// 1. 🟢 DIUBAH JADI STATEFULWIDGET: Supaya bisa panggil API pas pertama kali web dimuat
class HomeUnauthScreen extends StatefulWidget {
  const HomeUnauthScreen({super.key});

  @override
  State<HomeUnauthScreen> createState() => _HomeUnauthScreenState();
}

class _HomeUnauthScreenState extends State<HomeUnauthScreen> {
  @override
  void initState() {
    super.initState();
    // 2. 🟢 PEMICU API: Tembak backend Go-Fiber tepat setelah frame halaman siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).fetchHomeData();
    });
  }

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
              // 3. 🟢 GUNAKAN CONSUMER: Untuk mendengarkan perubahan state loading/error/sukses
              child: Consumer<MovieProvider>(
                builder: (context, movieProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 24),

                      // =========================================================
                      // KONDISI 1: JIKA LAGI LOADING AMBIL DATA DARI GOLANG
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
                      // KONDISI 2: JIKA KONEKSI INTERNET ERROR / BACKEND MATI
                      // =========================================================
                      else if (movieProvider.errorMessage.isNotEmpty)
                        SizedBox(
                          height: 350,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  movieProvider.errorMessage,
                                  style: const TextStyle(color: Colors.red, fontSize: 15),
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
                      // KONDISI 3: SUKSES (Tampilkan widget MovieSection aslimu)
                      // =========================================================
                      else ...[
                        // Section Top Movies
                        MovieSection(
                          title: "Top Movies",
                          movies: movieProvider.topMovies, 
                          isWide: true,
                          onMovieTap: null,
                        ),

                        const SizedBox(height: 24),

                        // Section Now Showing
                        MovieSection(
                          title: "Now Showing",
                          movies: movieProvider.nowPlaying, 
                          isWide: false,
                          onMovieTap: null,
                        ),
                      ],

                      const SizedBox(height: 80),

                      // Panggil widget AppFooter di sini
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