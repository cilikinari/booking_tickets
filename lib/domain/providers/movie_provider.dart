import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../repository/movie_repo.dart'; 

class MovieProvider with ChangeNotifier {
  final MovieRepository _movieRepository = MovieRepository();

  List<Movie> topMovies = [];
  List<Movie> nowPlaying = [];

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  List<Movie> _filteredMovies = [];
  bool _isSearching = false;

  List<Movie> get filteredMovies => _filteredMovies;
  bool get isSearching => _isSearching;

  Future<void> fetchHomeData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final hasilData = await _movieRepository.ambilDataHome();

      topMovies = hasilData['topMovies'] ?? [];
      nowPlaying = hasilData['nowPlaying'] ?? [];
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners(); // Beritahu UI kalau proses selesai
    }
  }

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
