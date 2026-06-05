class Cinema {
  final int id;
  final String name;
  final int cityId; // 🟢 1. TAMBAHKAN PROPERTI RELASI KOTA

  Cinema({
    required this.id, 
    required this.name,
    required this.cityId, // 🟢 2. MASUKKAN KE CONSTRUCTOR
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['cinema_name'] ?? 'Bioskop', 
      // 🟢 3. AMBIL DATA CITY_ID DARI JSON BACKEND GOLANG
      cityId: json['city_id'] ?? json['cityId'] ?? 0, 
    );
  }
}
