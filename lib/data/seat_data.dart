import 'models/seat.dart';

class SeatData {
  static const Set<String> bookedSeatIds = {
    'A1',
    'A2',
    'A5',
    'A6',
    'A7',
    'B2',
    'B3',
    'B8',
    'B9',
    'B10',
    'C4',
    'C5',
    'C9',
    'D1',
    'D4',
    'D5',
    'D9',
    'D10',
    'E3',
    'E6',
  };

  static List<List<Seat?>> generateRows() {
    const rowLetters = ['A', 'B', 'C', 'D', 'E', 'F'];
    const totalCols = 10;
    const aisleAfter = 4;

    return rowLetters.map((row) {
      final cols = <Seat?>[];
      for (int col = 1; col <= totalCols; col++) {
        // Add null for aisle
        if (col == aisleAfter + 1) cols.add(null);

        final id = '$row$col';
        cols.add(
          Seat(
            id: id,
            row: row,
            number: col,
            status: bookedSeatIds.contains(id)
                ? SeatStatus.booked
                : SeatStatus.available,
          ),
        );
      }
      return cols;
    }).toList();
  }
}
