import '../data/city_data.dart';

class CityRepository {
  // Fungsi murni untuk mengambil data daftar kota
  List<String> getAllCities() {
    return CityData.cities;
  }
}
