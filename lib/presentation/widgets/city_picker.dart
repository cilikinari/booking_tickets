import 'package:flutter/material.dart';
import '../../data/city_data.dart';
import '../../utils/constants.dart';

class CityPickerDialog extends StatefulWidget {
  final String currentCity;

  const CityPickerDialog({super.key, required this.currentCity});

  @override
  State<CityPickerDialog> createState() => _CityPickerDialogState();
}

class _CityPickerDialogState extends State<CityPickerDialog> {
  final TextEditingController _citySearchController = TextEditingController();

  @override
  void dispose() {
    _citySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Logic filter dipindah ke sini
    final filteredCities = CityData.cities
        .where(
          (city) => city.toLowerCase().contains(
            _citySearchController.text.toLowerCase(),
          ),
        )
        .toList();

    return Stack(
      children: [
        Positioned(
          top: 80,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 320,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              decoration: BoxDecoration(
                color: AppConstants.cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Text(
                      "Select your location",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildSearchInput(),
                  const SizedBox(height: 12),
                  _buildCityList(filteredCities),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _citySearchController,
                onChanged: (_) =>
                    setState(() {}), // Trigger rebuild hanya di widget ini
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: "Search city",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            if (_citySearchController.text.isNotEmpty)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                onPressed: () {
                  _citySearchController.clear();
                  setState(() {});
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityList(List<String> filteredCities) {
    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 12),
        itemCount: filteredCities.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.white.withOpacity(0.05),
          height: 1,
          indent: 20,
          endIndent: 20,
        ),
        itemBuilder: (context, index) {
          final city = filteredCities[index];
          final selected = city == widget.currentCity;

          return ListTile(
            leading: Icon(
              Icons.location_on,
              color: selected ? AppConstants.primaryColor : Colors.grey,
              size: 18,
            ),
            title: Text(
              city.toUpperCase(),
              style: TextStyle(
                color: selected ? AppConstants.primaryColor : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            dense: true,
            onTap: () {
              // Lempar data kota yang dipilih kembali ke HomeScreen
              Navigator.pop(context, city);
            },
          );
        },
      ),
    );
  }
}
