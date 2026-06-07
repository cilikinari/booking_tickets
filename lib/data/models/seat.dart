enum SeatStatus { available, booked, selected }

class Seat {
  final String id; 
  final String seatNumber;
  final SeatStatus status;

  const Seat({
    required this.id,
    required this.seatNumber,
    this.status = SeatStatus.available,
  });

  Seat copyWith({SeatStatus? status}) {
    return Seat(
      id: id,
      seatNumber: seatNumber,
      status: status ?? this.status,
    );
  }

  bool get isSelectable => status != SeatStatus.booked;

  factory Seat.fromJson(Map<String, dynamic> json) {
    String parseId(dynamic v) {
      if (v == null) return '';
      return v.toString();
    }

    SeatStatus parseStatus(dynamic status) {
      if (status == null) return SeatStatus.available;
      final s = status.toString().toLowerCase();
      if (s == 'booked') return SeatStatus.booked;
      if (s == 'selected') return SeatStatus.selected;
      if (s == 'available') return SeatStatus.available;
      // fallback
      return SeatStatus.available;
    }

    final String parsedId = parseId(json['id']);
    // Build seatNumber from multiple possible API shapes
    String parsedSeatNumber = '';
    if (json.containsKey('row') && json.containsKey('number')) {
      final r = json['row']?.toString() ?? '';
      final n = json['number']?.toString() ?? '';
      parsedSeatNumber = '$r$n';
    } else if (json.containsKey('row') && json.containsKey('col')) {
      final r = json['row']?.toString() ?? '';
      final n = json['col']?.toString() ?? '';
      parsedSeatNumber = '$r$n';
    } else if (json.containsKey('seat_number')) {
      parsedSeatNumber = json['seat_number']?.toString() ?? '';
    } else if (json.containsKey('name')) {
      parsedSeatNumber = json['name']?.toString() ?? '';
    } else if (json.containsKey('label')) {
      parsedSeatNumber = json['label']?.toString() ?? '';
    } else {
      parsedSeatNumber = '';
    }
    final SeatStatus parsedStatus = parseStatus(json['status']);

    return Seat(
      id: parsedId,
      seatNumber: parsedSeatNumber,
      status: parsedStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seat_number': seatNumber,
      'status': status.name,
    };
  }

  @override
  bool operator ==(Object other) => other is Seat && other.id == id;

  @override
  int get hashCode => id.hashCode;
}