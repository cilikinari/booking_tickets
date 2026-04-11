class Booking {
  final String movieTitle;
  final String cinema;
  final String date;
  final String time;
  final List<String> seats;
  final double totalPrice;
  final String status; // "upcoming" atau "history"

  Booking({
    required this.movieTitle,
    required this.cinema,
    required this.date,
    required this.time,
    required this.seats,
    required this.totalPrice,
    required this.status,
  });
}