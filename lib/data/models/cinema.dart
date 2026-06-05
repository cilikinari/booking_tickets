class Cinema {
  final int id;
  final String name;

  Cinema({required this.id, required this.name});

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      id: json['id'] ?? 0,
      // Antisipasi nama key dari Golang (bisa 'name' atau 'cinema_name')
      name: json['name'] ?? json['cinema_name'] ?? 'Bioskop', 
    );
  }
}