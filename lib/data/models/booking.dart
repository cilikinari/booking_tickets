class Booking {
  final String movieTitle;
  final String cinema;
  final String date;
  final String time;
  final List<String> seats;
  final double totalPrice;
  final String status;

  Booking({
    required this.movieTitle,
    required this.cinema,
    required this.date,
    required this.time,
    required this.seats,
    required this.totalPrice,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      movieTitle: json['film_title'] ?? json['movie_title'] ?? 'Unknown Movie',
      
      cinema: json['cinema_name'] ?? json['cinema'] ?? 'Unknown Cinema',
      
      date: (json['date'] ?? json['booking_date'] ?? '-').toString().split('T')[0],
      time: json['time'] ?? '-',
      seats: json['seats'] != null
          ? List<String>.from(json['seats'].map((x) => x.toString()))
          : [],
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      status: json['status'] ?? 'unknown',
    );
  }
}