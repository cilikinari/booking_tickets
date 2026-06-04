import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/booking_provider.dart';
import '../../utils/constants.dart';

class BookingSelection extends StatelessWidget {
  final BookingProvider provider; // Tetap biarkan parameter ini agar tidak error di DetailScreen

  const BookingSelection({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    // 🟢 MENGGUNAKAN WATCH AGAR UI MERESPON SAAT DATA API GOLANG MASUK
    final bookingWatch = context.watch<BookingProvider>();

    // Handling jika data di database kosong / tidak ada jadwal untuk film ini
    final List<String> cinemaList = bookingWatch.cinemas;
    final List<String> dateList = bookingWatch.dates;
    final List<String> timeList = bookingWatch.times;

    return Column(
      children: [
        // ==========================================
        // CHOOSE CINEMA DROPDOWN
        // ==========================================
        _buildSectionCard(
          title: "Choose Cinema",
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppConstants.inputColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                dropdownColor: AppConstants.cardColor,
                // 🟢 Jika data dari API kosong, value di-set ke text bantuan bawaan UI
                value: bookingWatch.selectedCinema.isNotEmpty ? bookingWatch.selectedCinema : "placeholder_cinema",
                items: cinemaList.isEmpty
                    ? [
                        const DropdownMenuItem(
                          value: "placeholder_cinema",
                          child: Text("Pilih Bioskop", style: TextStyle(color: Colors.white54)),
                        )
                      ]
                    : cinemaList.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                onChanged: cinemaList.isEmpty
                    ? null // Dropdown mati/disable kalau data API kosong
                    : (v) {
                        if (v != null) bookingWatch.selectCinema(v);
                      },
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ==========================================
        // DATE & TIME SELECTION
        // ==========================================
        _buildSectionCard(
          title: "Date & Time",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSelectHeader("Date"),
              // 🟢 Tampilkan tombol tanggal jika ada, atau teks bantuan jika kosong
              dateList.isEmpty
                  ? const Text("Pilih Studio/Bioskop terlebih dahulu", style: TextStyle(color: Colors.white30, fontSize: 14))
                  : _buildSelectList(
                      dateList,
                      bookingWatch.selectedDate,
                      (v) => bookingWatch.selectDate(v),
                    ),
              const SizedBox(height: 20),
              _buildSelectHeader("Time"),
              // 🟢 Tampilkan tombol jam jika ada, atau teks bantuan jika kosong
              timeList.isEmpty
                  ? const Text("Pilih Tanggal terlebih dahulu", style: TextStyle(color: Colors.white30, fontSize: 14))
                  : _buildSelectList(
                      timeList,
                      bookingWatch.selectedTime,
                      (v) => bookingWatch.selectTime(v),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppConstants.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      );

  Widget _buildSelectHeader(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          t,
          style: const TextStyle(
            color: AppConstants.textSecondary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _buildSelectList(List<String> items, String sel, Function(String) onSel) => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: items.map((i) {
          final isSel = i == sel;
          return GestureDetector(
            onTap: () => onSel(i),
            child: AnimatedContainer(
              duration: AppConstants.fastAnimation,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSel ? AppConstants.primaryColor : AppConstants.inputColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSel ? Colors.transparent : Colors.white10,
                ),
              ),
              child: Text(
                i,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      );
}