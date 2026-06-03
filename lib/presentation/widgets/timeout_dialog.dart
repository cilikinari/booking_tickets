import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class TimeoutDialog extends StatelessWidget {
  final VoidCallback onGotIt;

  const TimeoutDialog({super.key, required this.onGotIt});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: 320,
        padding: const EdgeInsets.fromLTRB(28, 30, 28, 24),
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 54,
              height: 54,
              child: const Icon(
                Icons.access_time_rounded,
                color: Colors.red,
                size: 50,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              "Time's up for payment",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "It's been 10 minutes, so your order has been canceled. But, feel free to order again!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFCFCFCF),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 86,
              height: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppConstants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                onPressed: onGotIt,
                child: const Text(
                  'Got it',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
