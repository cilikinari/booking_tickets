import '../data/movie_data.dart';

class BookingRepository {
  List<String> getCinemas() => MovieData.cinemas;
  List<String> getDates() => MovieData.dates;
  List<String> getTimes() => MovieData.times;
}
