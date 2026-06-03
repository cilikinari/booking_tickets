import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart'; // 1. Import helper global di sini

class BookingInfo extends StatelessWidget {
  final int totalPrice;
  final String selectedLabels;
  final double barWidth;
  final bool isDesktopOrWeb;
  final VoidCallback? onBooking;

  const BookingInfo({
    super.key,
    required this.totalPrice,
    required this.selectedLabels,
    required this.barWidth,
    required this.isDesktopOrWeb,
    this.onBooking,
  });

  // Fungsi _formatNumber lokal sudah dihapus dari sini supaya tidak duplikat

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: barWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── 1. SEAT LEGEND ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendDot(const Color(0xFFF5F5F5), 'Available'),
                const SizedBox(width: 24),
                _buildLegendDot(AppConstants.primaryColor, 'Booked'),
                const SizedBox(width: 24),
                _buildLegendDot(Colors.lightBlue, 'Selected'),
              ],
            ),
            const SizedBox(height: 16),

            // ── 2. BOOKING INFO CARD ──
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: AppConstants.cardColor,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            color: AppConstants.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          // 2. Ganti panggilannya menggunakan AppHelpers di sini
                          '${AppConstants.defaultCurrency}${AppHelpers.formatNumber(totalPrice)}',
                          style: const TextStyle(
                            color: AppConstants.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 36, color: Colors.white12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Seat',
                            style: TextStyle(
                              color: AppConstants.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedLabels,
                            style: const TextStyle(
                              color: AppConstants.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── 3. BUTTON BOOKING ──
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: isDesktopOrWeb ? 360 : double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    disabledBackgroundColor:
                        AppConstants.primaryColor.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                    ),
                  ),
                  onPressed: onBooking,
                  child: const Text(
                    'Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk bulatan legend
  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppConstants.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}