import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/datasources/movie_services.dart'; // 🟢 1. Import API Service kamu

class MovieProvider with ChangeNotifier {
  // Instance untuk memanggil API
  final MovieService _movieService = MovieService();

  // Data Master (Sekarang kosong dulu, diisi setelah API merespon)
  List<Movie> topMovies = [];
  List<Movie> nowPlaying = [];

  // 🟢 2. STATE BARU: Untuk kontrol Loading dan Error dari Internet
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // STATE SEARCH (Punya kamu tetap aman di sini)
  List<Movie> _filteredMovies = [];
  bool _isSearching = false;

  List<Movie> get filteredMovies => _filteredMovies;
  bool get isSearching => _isSearching;

  // 🟢 3. FUNGSI BARU: Mengambil data nyata dari Backend
  Future<void> fetchHomeData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Beritahu UI untuk menampilkan loading spinner

    try {
      // Panggil API service
      final List<Movie> fetchedMovies = await _movieService.fetchNowShowing();

      // 💡 TRIK MEMBELAH DATA:
      // Ambil 5 film pertama untuk Top Movies
      topMovies = fetchedMovies.take(5).toList();
      // Masukkan semua film ke Now Playing
      nowPlaying = fetchedMovies;
    } catch (e) {
      // Tangkap pesan error jika server mati/gagal koneksi
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners(); // Beritahu UI kalau proses download selesai
    }
  }

  // 🟢 4. FITUR SEARCH KAMU (100% Utuh & Bekerja Otomatis dengan Data API)
  void searchMovies(String query) {
    if (query.isEmpty) {
      _isSearching = false;
      _filteredMovies = [];
      notifyListeners();
      return;
    }

    final String lowerQuery = query.toLowerCase();
    final List<Movie> allMovies = [...topMovies, ...nowPlaying];

    _filteredMovies = allMovies
        .where(
          (movie) =>
              movie.title.toLowerCase().contains(lowerQuery) ||
              movie.genres.any(
                (genre) => genre.name.toLowerCase().contains(lowerQuery),
              ),
        )
        .toSet()
        .toList();

    _isSearching = true;
    notifyListeners();
  }

  void clearSearch() {
    _isSearching = false;
    _filteredMovies = [];
    notifyListeners();
  }
}
