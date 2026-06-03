import 'package:flutter/material.dart';
import '../../repository/city_repo.dart';

class LocationProvider extends ChangeNotifier {
  final CityRepository _cityRepository = CityRepository();

  String _selectedCity = "Choose City"; // Kota default awal aplikasi
  List<String> _filteredCities = [];

  // Getter untuk dibaca oleh UI
  String get selectedCity => _selectedCity;
  List<String> get filteredCities => _filteredCities.isEmpty
      ? _cityRepository.getAllCities()
      : _filteredCities;

  // 🟢 LOGIKA BISNIS: Proses pencarian kota dipindahkan ke sini
  void filterCities(String query) {
    final allCities = _cityRepository.getAllCities();

    if (query.isEmpty) {
      _filteredCities = allCities;
    } else {
      _filteredCities = allCities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners(); // Menggantikan fungsi setState() di UI
  }

  // Fungsi untuk memperbarui kota yang dipilih secara global di aplikasi
  void updateCity(String newCity) {
    _selectedCity = newCity;
    notifyListeners();
  }
}
