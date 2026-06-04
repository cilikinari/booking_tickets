class Schedule {
  final int id;
  final int movieId;
  final int studioId; // 🟢 KITA TANGKAP ID STUDIO-NYA
  final String date;
  final String time;
  final int price;

  Schedule({
    required this.id,
    required this.movieId,
    required this.studioId,
    required this.date,
    required this.time,
    required this.price,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    String rawDate = json['date'] ?? '';
    if (rawDate.length >= 10) rawDate = rawDate.substring(0, 10);

    String rawTime = json['time'] ?? '';
    if (rawTime.length >= 5) rawTime = rawTime.substring(0, 5);

    return Schedule(
      id: json['id'] ?? 0,
      movieId: json['film_id'] ?? 0,
      studioId: json['studio_id'] ?? 0, // 🟢 SESUAI JSON GOLANG
      date: rawDate,
      time: rawTime,
      price: json['price'] ?? 0,
    );
  }
}