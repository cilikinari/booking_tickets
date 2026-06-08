import '../data/models/movie.dart';
import '../data/datasources/movie_services.dart';

class MovieRepository {
  final MovieService _movieService = MovieService();

  Future<Map<String, List<Movie>>> ambilDataHome() async {
    // 1. Ambil data asli dari internet via service
    final List<Movie> semuaFilm = await _movieService.fetchNowShowing(); //ngambil data semua film yang sedang tayang, nanti diolah lagi di bawah sesuai kebutuhan provider

    // 2. Olah logika pembelahan data di sini (Bukan di Provider!)
    final List<Movie> topMovies = semuaFilm.take(5).toList();
    final List<Movie> nowPlaying = semuaFilm;

    // 3. Kembalikan dalam bentuk paket Map yang rapi
    return {
      'topMovies': topMovies,
      'nowPlaying': nowPlaying,
    };
  }
}
