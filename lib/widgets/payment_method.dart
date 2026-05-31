import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PaymentMethodsCard extends StatelessWidget {
  final String selectedPayment;
  final ValueChanged<String> onMethodSelected;

  // Pindahkan daftar metodenya ke sini karena datanya statis
  static const _paymentMethods = [
    'OVO',
    'Dana',
    'Gopay',
    'LinkAja',
    'Shopeepay',
  ];

  const PaymentMethodsCard({
    super.key,
    required this.selectedPayment,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Methods',
          style: TextStyle(
            color: AppConstants.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: AppConstants.cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: _paymentMethods
                .map((method) => _buildPaymentTile(method))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTile(String method) {
    final isSelected = selectedPayment == method;
    return ListTile(
      onTap: () => onMethodSelected(method),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      tileColor: isSelected ? Colors.white10 : Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        method,
        style: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: SizedBox(
        width: 34,
        height: 34,
        child: Center(
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.cyan : Colors.white70,
                width: 2.5,
              ),
              color: isSelected ? Colors.cyan : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}