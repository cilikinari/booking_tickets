import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../repository/movie_repo.dart'; // 🟢 SEKARANG IMPORT REPOSITORY

class MovieProvider with ChangeNotifier {
  // 🟢 Panggil si pelayan data (Repository), bukan API langsung
  final MovieRepository _movieRepository = MovieRepository();

  // Data Master (Diisi setelah mendapat hasil bersih dari Repository)
  List<Movie> topMovies = [];
  List<Movie> nowPlaying = [];

  // STATE: Kontrol Loading dan Error
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // STATE SEARCH (Fitur pencarian lokal kamu tetap aman di sini)
  List<Movie> _filteredMovies = [];
  bool _isSearching = false;

  List<Movie> get filteredMovies => _filteredMovies;
  bool get isSearching => _isSearching;

  // 🟢 FUNGSI BARU: Jauh lebih bersih karena tugas berat dipindah ke Repo
  Future<void> fetchHomeData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Beritahu UI untuk menampilkan loading spinner

    try {
      // Provider tinggal terima hasil bersih yang sudah dibelah oleh Repository
      final hasilData = await _movieRepository.ambilDataHome();

      topMovies = hasilData['topMovies'] ?? [];
      nowPlaying = hasilData['nowPlaying'] ?? [];
    } catch (e) {
      // Tangkap pesan error jika server mati/gagal koneksi
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners(); // Beritahu UI kalau proses selesai
    }
  }

  // 🟢 FITUR SEARCH KAMU (100% Utuh & Tetap Berada di Sini karena Mengatur UI)
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
    notifyListeners(); // Menyuruh layar UI menggambar ulang hasil pencarian
  }

  void clearSearch() {
    _isSearching = false;
    _filteredMovies = [];
    notifyListeners();
  }
}
