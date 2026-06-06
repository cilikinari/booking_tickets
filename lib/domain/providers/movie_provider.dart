import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../repository/movie_repo.dart'; // 🟢 SEKARANG IMPORT REPOSITORY

class MovieProvider with ChangeNotifier {

  final MovieRepository _movieRepository = MovieRepository();

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

  Future<void> fetchHomeData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); 

    try {
      // Provider tinggal terima hasil bersih yang sudah dibelah oleh Repository
      final hasilData = await _movieRepository.ambilDataHome();

//ini hasil dari repo ngambil data trs hasilnya masuk ke masing2 yg udah difilter diatas
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

//ini ngehapus pencarian kalo dari backspace
//query itu adalah wadah yang selalu merekam apa pun yang ada di dalam kotak pencarian (search bar) setiap detiknya, misal cuma ngetik B aja pun itu artinya ada.
  void searchMovies(String query) {
    if (query.isEmpty) {
      _isSearching = false;
      _filteredMovies = [];
      notifyListeners();
      return;
    }

    final String lowerQuery = query.toLowerCase();
    final List<Movie> allMovies = [...topMovies, ...nowPlaying];

//ini buat nyari data semua movie dan genre yg sesuai pencarian user dan masuk ke _filteredMovies
    _filteredMovies = allMovies
        .where(
          (movie) =>
              movie.title.toLowerCase().contains(lowerQuery) ||
              movie.genres.any(
                (genre) => genre.name.toLowerCase().contains(lowerQuery),
              ),
        )
        // .toSet(): Fungsi ini ibarat saringan ajaib. Dalam dunia programming, sebuah Set tidak mengizinkan ada dua barang yang sama persis di dalamnya. 
        //Begitu dilewati ke .toSet(), kembaran film yang duplikat tadi otomatis dibuang hingga tersisa satu saja.
        // Setelah hasil saringannya bersih dari duplikat, data ini dikembalikan menjadi bentuk daftar (List) yang rapi, lalu ditaruh ke keranjang _filteredMovies
        .toSet()
        .toList();

    _isSearching = true;
    notifyListeners(); // Menyuruh layar UI menggambar ulang hasil pencarian
  }

// Fitur untuk membersihkan hasil search kalo diklik x
  void clearSearch() {
    _isSearching = false;
    _filteredMovies = [];
    notifyListeners();
  }
}
