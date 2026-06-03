enum SeatStatus { available, booked, selected }

class Seat {
  final String id;
  final String row;
  final int number;
  final SeatStatus status;

  const Seat({
    required this.id,
    required this.row,
    required this.number,
    this.status = SeatStatus.available,
  });

  Seat copyWith({SeatStatus? status}) {
    return Seat(
      id: id,
      row: row,
      number: number,
      status: status ?? this.status,
    );
  }

  bool get isSelectable => status != SeatStatus.booked;

  @override
  bool operator ==(Object other) => other is Seat && other.id == id;

  @override
  int get hashCode => id.hashCode;
}