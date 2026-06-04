class Movie {
  final int id;
  final String title;
  final int duration; // Di BE berupa int (menit)
  final String synopsis;
  final String posterUrl;
  final String ageRating;
  final int price; // Di BE berupa int
  final int releaseYear; // Di BE berupa int
  final List<Genre> genres; // Menampung list genre dari BE

  Movie({
    required this.id,
    required this.title,
    required this.duration,
    required this.synopsis,
    required this.posterUrl,
    required this.ageRating,
    required this.price,
    required this.releaseYear,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['Title'] ?? '',
      duration: json['duration'] ?? json['Duration'] ?? 0,
      synopsis: json['synopsis'] ?? json['Synopsis'] ?? '',

      // 🔴 ANTISIPASI BERBAGAI FORMAT KEY POSTER
      posterUrl:
          json['poster_url'] ??
          json['posterUrl'] ??
          json['PosterUrl'] ??
          json['poster'] ??
          '',

      ageRating:
          json['age_rating'] ?? json['ageRating'] ?? json['AgeRating'] ?? '',
      price: json['price'] ?? json['Price'] ?? 0,
      releaseYear:
          json['release_year'] ??
          json['releaseYear'] ??
          json['ReleaseYear'] ??
          0,

      // 🔴 ANTISIPASI DATA GENRE KOSONG / BEDA HURUFS
      genres: (json['genres'] ?? json['Genres']) != null
          ? List<Genre>.from(
              (json['genres'] ?? json['Genres']).map((x) => Genre.fromJson(x)),
            )
          : [],
    );
  }
}

// 🟢 Tambahkan ini di file yang sama (atau pisah) untuk handle model Genre-nya
class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] ?? 0,
      // 🟢 PERBAIKAN: Tangkap berbagai kemungkinan nama key dari Golang
      name:
          json['name'] ??
          json['genre_name'] ??
          json['Name'] ??
          json['nama'] ??
          'Unknown',
    );
  }
}
