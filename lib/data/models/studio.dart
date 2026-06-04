class Studio {
  final int id;
  final int cinemaId; // 🟢 TAMBAHAN BARU
  final String studioName;

  Studio({required this.id, required this.cinemaId, required this.studioName});

  factory Studio.fromJson(Map<String, dynamic> json) {
    return Studio(
      id: json['id'] ?? 0,
      cinemaId: json['cinema_id'] ?? 0, // 🟢 MENANGKAP ID CINEMA
      studioName: json['studio_name'] ?? 'Unknown Studio',
    );
  }
}