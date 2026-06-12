import '../data/models/movie.dart';
import '../data/datasources/movie_services.dart';

class MovieRepository {
  final MovieService _movieService = MovieService();

  Future<Map<String, List<Movie>>> ambilDataHome() async {
    
    final List<Movie> semuaFilm = await _movieService.fetchNowShowing(); 
    
    final List<Movie> topMovies = semuaFilm.take(5).toList();
    final List<Movie> nowPlaying = semuaFilm;

    return {
      'topMovies': topMovies,
      'nowPlaying': nowPlaying,
    };
  }
}
