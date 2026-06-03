import 'package:flutter/material.dart';
import '../../domain/providers/booking_provider.dart';
import '../../utils/constants.dart';

class BookingSelection extends StatelessWidget {
  final BookingProvider provider;

  const BookingSelection({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Choose Cinema
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
                value: provider.selectedCinema,
                items: provider.cinemas
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: const TextStyle(color: Colors.white)),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) provider.selectCinema(v);
                },
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Date & Time
        _buildSectionCard(
          title: "Date & Time",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSelectHeader("Date"),
              _buildSelectList(
                provider.dates,
                provider.selectedDate,
                (v) => provider.selectDate(v),
              ),
              const SizedBox(height: 20),
              _buildSelectHeader("Time"),
              _buildSelectList(
                provider.times,
                provider.selectedTime,
                (v) => provider.selectTime(v),
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