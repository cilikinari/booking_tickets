import 'package:flutter/material.dart';
import '../models/seat.dart';
import '../utils/constants.dart';

class SeatItem extends StatelessWidget {
  final Seat seat;
  final VoidCallback onTap;

  const SeatItem({
    super.key,
    required this.seat,
    required this.onTap,
  });

  Color get _seatColor {
    switch (seat.status) {
      case SeatStatus.available:
        return const Color.fromARGB(255, 252, 252, 252);
      case SeatStatus.booked:
        return AppConstants.primaryColor;
      case SeatStatus.selected:
        return Colors.lightBlue;
    }
  }

  Color get _seatTextColor {
    switch (seat.status) {
      case SeatStatus.available:
        return Colors.black87;
      case SeatStatus.booked:
      case SeatStatus.selected:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: seat.isSelectable ? onTap : null,
      child: AnimatedContainer(
        duration: AppConstants.fastAnimation,
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: _seatColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            seat.id,
            style: TextStyle(
              color: _seatTextColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}