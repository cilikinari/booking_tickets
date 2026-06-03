import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/models/seat.dart';
import '../../data/models/booking.dart'; // 🟢 Pastikan model Booking diimport
import '../../repository/booking_repo.dart';

class BookingProvider extends ChangeNotifier {
  final BookingRepository _repository = BookingRepository();

  List<String> get cinemas => _repository.getCinemas();
  List<String> get dates => _repository.getDates();
  List<String> get times => _repository.getTimes();

  Movie? _activeMovie;
  String _selectedCinema = "";
  String _selectedDate = "";
  String _selectedTime = "";
  List<Seat> _selectedSeats = [];

  // 🟢 STATE BARU UNTUK HALAMAN PEMBAYARAN
  String _selectedPayment = '';
  int _remainingSeconds = 100; // 10 * 10 detik sesuai kode Anda
  Timer? _timer;
  bool _isTimeout = false;

  // GETTER
  Movie? get activeMovie => _activeMovie;
  String get selectedCinema =>
      _selectedCinema.isEmpty ? cinemas[0] : _selectedCinema;
  String get selectedDate => _selectedDate.isEmpty ? dates[0] : _selectedDate;
  String get selectedTime => _selectedTime.isEmpty ? times[2] : _selectedTime;
  List<Seat> get selectedSeats => _selectedSeats;
  int get totalPrice =>
      _selectedSeats.length * 50000; // Contoh harga default tiket

  String get selectedPayment => _selectedPayment;
  int get remainingSeconds => _remainingSeconds;
  bool get isTimeout => _isTimeout;
  bool get canPay => _selectedPayment.isNotEmpty;

  String get selectedLabels {
    if (_selectedSeats.isEmpty) return 'No seat selected';
    return _selectedSeats.map((s) => s.id).join(', ');
  }

  // Format teks waktu mm:ss untuk UI
  String get formattedCountdown {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void startBooking(Movie movie) {
    _activeMovie = movie;
    _selectedCinema = cinemas[0];
    _selectedDate = dates[0];
    _selectedTime = times[2];
    _selectedSeats = [];
    _selectedPayment = '';
    _isTimeout = false;
    _remainingSeconds = 100;
    _timer?.cancel();
  }

  void selectCinema(String cinema) {
    _selectedCinema = cinema;
    notifyListeners();
  }

  void selectDate(String date) {
    _selectedDate = date;
    notifyListeners();
  }

  void selectTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  void updateSelectedSeats(List<Seat> seats) {
    _selectedSeats = List.from(seats);
    notifyListeners();
  }

  // 🟢 LOGIKA BISNIS: Menjalankan penghitung waktu mundur dari dalam Provider
  void startPaymentTimer(VoidCallback onTimeoutCallback) {
    _timer?.cancel();
    _remainingSeconds = 100;
    _isTimeout = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        _remainingSeconds = 0;
        _isTimeout = true;
        _timer?.cancel();
        notifyListeners();
        onTimeoutCallback(); // Picu dialog pop-up di UI saat waktu habis
        return;
      }
      _remainingSeconds--;
      notifyListeners(); // Otomatis memperbarui teks hitung mundur di layar UI
    });
  }

  void selectPaymentMethod(String method) {
    _selectedPayment = method;
    notifyListeners();
  }

  // 🟢 LOGIKA BISNIS: Merakit objek Booking sebelum dikirim ke server/halaman sukses
  Booking completePayment() {
    _timer?.cancel();

    return Booking(
      movieTitle: _activeMovie!.title,
      cinema: selectedCinema,
      date: selectedDate,
      time: selectedTime,
      seats: _selectedSeats.map((s) => s.id).toList(),
      totalPrice: totalPrice.toDouble(),
      status: 'upcoming',
    );
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
