import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 🟢 Wajib import Provider
import '../../data/models/seat.dart';
import '../../domain/providers/seat_provider.dart'; // 🟢 Sesuaikan path ke SeatProvider
import '../../utils/constants.dart';
import 'seat_item.dart';

class CinemaSeatLayout extends StatelessWidget {
  final ValueChanged<List<Seat>> onSelectionChanged;

  const CinemaSeatLayout({super.key, required this.onSelectionChanged});

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

  List<List<Seat?>> _buildGridFromApi(List<Seat> apiSeats) {
    Map<String, List<Seat>> rowMap = {};
    
    // 1. Kelompokkan berdasarkan huruf depan (Misal: "A1" dan "A2" masuk grup "A")
    for (var seat in apiSeats) {
      if (seat.seatNumber.isEmpty) continue;
      String rowLetter = seat.seatNumber[0].toUpperCase();
      rowMap.putIfAbsent(rowLetter, () => []).add(seat);
    }

    // 2. Urutkan baris dari A sampai huruf terakhir
    var sortedRowKeys = rowMap.keys.toList()..sort();
    List<List<Seat?>> grid = [];

    for (var key in sortedRowKeys) {
      var rowSeats = rowMap[key]!;
      
      // 3. Urutkan angka kursinya (1, 2, 3, dst)
      rowSeats.sort((a, b) {
        int numA = int.tryParse(a.seatNumber.substring(1)) ?? 0;
        int numB = int.tryParse(b.seatNumber.substring(1)) ?? 0;
        return numA.compareTo(numB);
      });

      // 4. Masukkan kursi ke baris, dan potong dengan "Lorong" (null) setelah kursi ke-4
      List<Seat?> rowWithAisle = [];
      for (int i = 0; i < rowSeats.length; i++) {
        rowWithAisle.add(rowSeats[i]);
        if (i == 3) { // i == 3 artinya kursi ke-4 (karena mulai dari 0)
          rowWithAisle.add(null); // Ini Lorong
        }
      }
      grid.add(rowWithAisle);
    }

    return grid;
  }

  @override
  Widget build(BuildContext context) {
    // Pantau SeatProvider
    final seatProvider = Provider.of<SeatProvider>(context);

    // Kalau sedang loading narik data dari Golang
    if (seatProvider.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40.0),
        child: CircularProgressIndicator(color: AppConstants.primaryColor),
      );
    }

    // Kalau belum ada data atau kosong
    if (seatProvider.seats.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40.0),
        child: Text(
          'Denah kursi tidak tersedia',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    // Panggil fungsi ajaib pembuat grid
    final grid = _buildGridFromApi(seatProvider.seats);
    final seatSize = _calcSeatSize(context);

    return Column(
      children: [
        _buildScreenCurve(),
        const SizedBox(height: 28),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(), // Biar scrollnya mantul mulus
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(grid.length, (rowIdx) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(grid[rowIdx].length, (colIdx) {
                      final seat = grid[rowIdx][colIdx];

                      // Kalau ini area Lorong (null), beri jarak kosong
                      if (seat == null) return const SizedBox(width: 18);

                      // Cek apakah kursi ini ada di daftar pilihan User
                      final isSelected = seatProvider.selectedSeats.contains(seat);

                      // Timpa statusnya jadi 'selected' hanya untuk keperluan UI (warna hijau)
                      final displaySeat = isSelected
                          ? seat.copyWith(status: SeatStatus.selected)
                          : seat;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: SeatItem(
                          seat: displaySeat,
                          size: seatSize,
                          onTap: () {
                            // 1. Eksekusi logika pilih kursi di SeatProvider
                            seatProvider.toggleSeat(seat);
                            // 2. Beritahu BookingProvider kalau ada perubahan harga/tiket
                            onSelectionChanged(seatProvider.selectedSeats);
                          },
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
        ),
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
}

class _ScreenCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
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