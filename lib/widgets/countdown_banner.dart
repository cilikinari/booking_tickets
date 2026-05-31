import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CountdownBanner extends StatelessWidget {
  final String formattedCountdown;

  const CountdownBanner({
    super.key, 
    required this.formattedCountdown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Yuk, selesaikan pembayaranmu dalam',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            formattedCountdown,
            style: const TextStyle(
              color: AppConstants.primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}