import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/movie_data.dart'; // 🟢 1. Import source data dummy kamu

class MovieProvider extends ChangeNotifier {
  // Data Master
  List<Movie> topMovies = [];
  List<Movie> nowPlaying = [];

  // 🟢 2. Buat Constructor untuk menyalin data dummy ke State Provider
  MovieProvider() {
    topMovies = MovieData.topMovies;
    nowPlaying = MovieData.nowPlaying;
  }

  // STATE BARU: Khusus untuk menampung hasil pencarian
  List<Movie> _filteredMovies = [];
  bool _isSearching = false;

  // GETTER
  List<Movie> get filteredMovies => _filteredMovies;
  bool get isSearching => _isSearching;

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
              movie.genre.toLowerCase().contains(lowerQuery),
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
