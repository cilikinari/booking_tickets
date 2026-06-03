import 'package:flutter/material.dart';
import '../../data/models/seat.dart';
import '../../data/seat_data.dart';
import '../../utils/constants.dart';
import 'seat_item.dart';

class CinemaSeatLayout extends StatefulWidget {
  final ValueChanged<List<Seat>> onSelectionChanged;

  const CinemaSeatLayout({super.key, required this.onSelectionChanged});

  @override
  State<CinemaSeatLayout> createState() => _CinemaSeatLayoutState();
}

class _CinemaSeatLayoutState extends State<CinemaSeatLayout> {
  late List<List<Seat?>> _rows;

  @override
  void initState() {
    super.initState();
    _rows = SeatData.generateRows();
  }

  void _toggleSeat(int rowIdx, int colIdx) {
    final seat = _rows[rowIdx][colIdx];
    if (seat == null || !seat.isSelectable) return;

    setState(() {
      _rows[rowIdx][colIdx] = seat.copyWith(
        status: seat.status == SeatStatus.selected
            ? SeatStatus.available
            : SeatStatus.selected,
      );
    });

    // Kirim data kursi yang dipilih kembali ke halaman SeatScreen
    final selectedSeats = _rows
        .expand((r) => r)
        .whereType<Seat>()
        .where((s) => s.status == SeatStatus.selected)
        .toList();

    widget.onSelectionChanged(selectedSeats);
  }

  double _calcSeatSize(BuildContext context) {
    const seatsPerRow = 10;
    const aisleWidth = 18.0;
    const gridPadding = 32.0;
    const totalSeatSpacing = 60.0;

    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth.clamp(0.0, AppConstants.maxWidth);

    final usable = contentWidth - gridPadding - aisleWidth - totalSeatSpacing;
    final size = usable / seatsPerRow;

    return size.clamp(24.0, 52.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildScreenCurve(),
        const SizedBox(height: 28),
        _buildSeatGrid(),
      ],
    );
  }

  Widget _buildScreenCurve() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          CustomPaint(
            painter: _ScreenCurvePainter(),
            child: const SizedBox(width: double.infinity, height: 18),
          ),
          const SizedBox(height: 6),
          const Text(
            'LAYAR BIOSKOP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              letterSpacing: 2.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final seatSize = _calcSeatSize(context);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: List.generate(_rows.length, (rowIdx) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_rows[rowIdx].length, (colIdx) {
                    final seat = _rows[rowIdx][colIdx];
                    if (seat == null) return const SizedBox(width: 18);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: SeatItem(
                        seat: seat,
                        size: seatSize,
                        onTap: () => _toggleSeat(rowIdx, colIdx),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _ScreenCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width / 2, 0, size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
