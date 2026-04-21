import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/seat.dart';
import '../utils/constants.dart';
import '../widgets/seat_item.dart';
import 'payment_screen.dart';

class SeatScreen extends StatefulWidget {
  final Movie movie;
  final int ticketPrice;
  final String cinema;
  final String date;
  final String time;

  const SeatScreen({
    super.key,
    required this.movie,
    this.ticketPrice = AppConstants.defaultTicketPrice,
    required this.cinema,
    required this.date,
    required this.time,
  });

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  late List<List<Seat?>> _rows;

  static const _bookedIds = {
    'A1','A2','A5','A6','A7',
    'B2','B3','B8','B9','B10',
    'C4','C5','C9',
    'D1','D4','D5','D9','D10',
    'E3','E6',
  };

  @override
  void initState() {
    super.initState();
    _rows = _generateRows();
  }

  List<List<Seat?>> _generateRows() {
    const rowLetters = ['A', 'B', 'C', 'D', 'E', 'F'];
    const totalCols = 10;
    const aisleAfter = 4; 

    return rowLetters.map((row) {
      final cols = <Seat?>[];
      for (int col = 1; col <= totalCols; col++) {
        if (col == aisleAfter + 1) cols.add(null);

        final id = '$row$col';
        cols.add(Seat(
          id: id,
          row: row,
          number: col,
          status: _bookedIds.contains(id)
              ? SeatStatus.booked
              : SeatStatus.available,
        ));
      }
      return cols;
    }).toList();
  }

  // ── State helpers ──────────────────────────────────────────

  List<Seat> get _selectedSeats => _rows
      .expand((r) => r)
      .whereType<Seat>()
      .where((s) => s.status == SeatStatus.selected)
      .toList();

  int get _totalPrice => _selectedSeats.length * widget.ticketPrice;

  String get _selectedLabels {
    final labels = _selectedSeats.map((s) => s.id).toList()..sort();
    return labels.isEmpty ? '-' : labels.join(', ');
  }

  // ── Actions ────────────────────────────────────────────────

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
  }

  void _onBooking() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PaymentScreen(
        movie: widget.movie,
        cinema: widget.cinema,
        date: widget.date,
        time: widget.time,
        seats: _selectedSeats.map((s) => s.id).toList(),
        totalPrice: _totalPrice.toDouble(),
      ),
    ),
  );
}

  // ── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          widget.movie.title,
          style: const TextStyle(
            color: AppConstants.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildScreenCurve(),
          const SizedBox(height: 28),
          Expanded(child: _buildSeatGrid()),
          _buildLegend(),
          const SizedBox(height: 8),
          _buildBottomBar(),
          const SizedBox(height: 20),
        ],
      ),
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
          Text(
            'LAYAR BIOSKOP',
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
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
      const seatsPerRow = 10;
      const aisleWidth = 18.0;
      const horizontalPadding = 32.0; // 16 * 2
      const seatHorizontalSpacing = 6.0; // 3 * 2 per seat

      final availableWidth = constraints.maxWidth
          - horizontalPadding
          - aisleWidth;
      final seatSize = (availableWidth - (seatHorizontalSpacing * seatsPerRow))
          / seatsPerRow;

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: List.generate(_rows.length, (rowIdx) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_rows[rowIdx].length, (colIdx) {
                  final seat = _rows[rowIdx][colIdx];

                  if (seat == null) {
                    return const SizedBox(width: 18);
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: SeatItem(
                      seat: seat,
                      size: seatSize, // ← pass size dynamic
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

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendDot(const Color.fromARGB(255, 246, 245, 245), 'Available'),
        const SizedBox(width: 24),
        _legendDot(AppConstants.primaryColor, 'Booked'),
        const SizedBox(width: 24),
        _legendDot(Colors.lightBlue, 'Selected'),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                color: AppConstants.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding),
      child: Column(
        children: [
          // Info total & seat
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppConstants.cardColor,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Row(
              children: [
                // Total price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              color: AppConstants.textMuted, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        '${AppConstants.defaultCurrency}${_formatNumber(_totalPrice)}',
                        style: const TextStyle(
                          color: AppConstants.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(width: 1, height: 36, color: Colors.white12),
                // Selected seats
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Seat',
                            style: TextStyle(
                                color: AppConstants.textMuted, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          _selectedLabels,
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
          // Booking button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                disabledBackgroundColor: AppConstants.primaryColor.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadius),
                ),
              ),
              onPressed: _selectedSeats.isEmpty ? null : _onBooking,
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
        ],
      ),
    );
  }

  String _formatNumber(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');
  }
}

class _ScreenCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5)
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