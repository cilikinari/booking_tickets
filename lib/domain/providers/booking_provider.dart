import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/models/seat.dart';
import '../../data/models/booking.dart';
import '../../data/models/schedule.dart';
import '../../data/models/studio.dart';
import '../../data/models/cinema.dart'; // 🟢 IMPORT MODEL CINEMA
import '../../repository/booking_repo.dart';

class BookingProvider extends ChangeNotifier {
  final BookingRepository _repository = BookingRepository();

  List<Schedule> _allSchedules = [];
  List<Studio> _allStudios = [];
  List<Cinema> _allCinemas = []; // 🟢 MENYIMPAN DATA DARI /cinema

  bool _isLoading = false;
  String _errorMessage = '';

  Movie? _activeMovie;
  String _selectedCinema = ""; // Berisi teks gabungan (contoh: "CGV - IMAX")
  String _selectedDate = "";
  String _selectedTime = "";
  List<Seat> _selectedSeats = [];
  String _selectedPayment = '';
  int _remainingSeconds = 100;
  Timer? _timer;
  bool _isTimeout = false;

  Movie? get activeMovie => _activeMovie;
  List<Seat> get selectedSeats => _selectedSeats;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedPayment => _selectedPayment;
  int get remainingSeconds => _remainingSeconds;
  bool get isTimeout => _isTimeout;
  bool get canPay => _selectedPayment.isNotEmpty;

  // ========================================================
  // 🟢 FUNGSI HELPER: MENGGABUNGKAN NAMA BIOSKOP + STUDIO
  // ========================================================
  String _getCombinedName(int studioId) {
    final studio = _allStudios.firstWhere(
      (st) => st.id == studioId,
      orElse: () => Studio(id: 0, cinemaId: 0, studioName: ''),
    );
    final cinema = _allCinemas.firstWhere(
      (c) => c.id == studio.cinemaId,
      orElse: () => Cinema(id: 0, name: ''),
    );

    if (cinema.name.isEmpty) return studio.studioName;
    return "${cinema.name} - ${studio.studioName}"; // Output: "XXI Mall - Premiere"
  }

  // ========================================================
  // 🟢 GETTER DATA UI
  // ========================================================

  List<String> get cinemas {
    return _allSchedules
        .where((s) => s.movieId.toString() == _activeMovie?.id.toString())
        .map((s) => _getCombinedName(s.studioId))
        .toSet()
        .toList();
  }

  List<String> get dates {
    if (_selectedCinema.isEmpty) return [];
    return _allSchedules
        .where((s) {
          if (s.movieId.toString() != _activeMovie?.id.toString()) return false;
          return _getCombinedName(s.studioId) == _selectedCinema;
        })
        .map((s) => s.date)
        .toSet()
        .toList();
  }

  List<String> get times {
    if (_selectedCinema.isEmpty || _selectedDate.isEmpty) return [];
    return _allSchedules
        .where((s) {
          if (s.movieId.toString() != _activeMovie?.id.toString()) return false;
          if (s.date != _selectedDate) return false;
          return _getCombinedName(s.studioId) == _selectedCinema;
        })
        .map((s) => s.time)
        .toSet()
        .toList();
  }

  int get ticketPrice {
    if (_allSchedules.isEmpty || _selectedCinema.isEmpty) return 0;
    try {
      final currentSchedule = _allSchedules.firstWhere((s) {
        if (s.movieId.toString() != _activeMovie?.id.toString()) return false;
        if (s.date != _selectedDate) return false;
        if (s.time != _selectedTime) return false;
        return _getCombinedName(s.studioId) == _selectedCinema;
      });
      return currentSchedule.price;
    } catch (e) {
      return 0;
    }
  }

  // Return currently selected schedule id, or -1 if none
  int get selectedScheduleId {
    try {
      final currentSchedule = _allSchedules.firstWhere((s) {
        if (s.movieId.toString() != _activeMovie?.id.toString()) return false;
        if (s.date != _selectedDate) return false;
        if (s.time != _selectedTime) return false;
        return _getCombinedName(s.studioId) == _selectedCinema;
      });
      return currentSchedule.id;
    } catch (e) {
      return -1;
    }
  }

  int get totalPrice => _selectedSeats.length * ticketPrice;
  String get selectedCinema => _selectedCinema;
  String get selectedDate => _selectedDate;
  String get selectedTime => _selectedTime;

  String get selectedLabels {
    if (_selectedSeats.isEmpty) return 'No seat selected';
    return _selectedSeats.map((s) => s.id).join(', ');
  }

  String get formattedCountdown {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> startBooking(Movie movie) async {
    _activeMovie = movie;
    _selectedCinema = "";
    _selectedDate = "";
    _selectedTime = "";
    _selectedSeats = [];
    _selectedPayment = '';
    _isTimeout = false;
    _remainingSeconds = 100;
    _timer?.cancel();

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // 🟢 TEMBAK 3 API SEKALIGUS UNTUK MERAKIT RELASI DATABASE
      await Future.wait([
        _repository.getSchedules().then((value) => _allSchedules = value),
        _repository.getStudios().then((value) => _allStudios = value),
        _repository.getCinemas().then((value) => _allCinemas = value),
      ]);

      if (cinemas.isNotEmpty) {
        _selectedCinema = cinemas[0];
        if (dates.isNotEmpty) {
          _selectedDate = dates[0];
          if (times.isNotEmpty) {
            _selectedTime = times[0];
          }
        }
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCinema(String cinema) {
    _selectedCinema = cinema;
    _selectedDate = dates.isNotEmpty ? dates[0] : "";
    _selectedTime = times.isNotEmpty ? times[0] : "";
    notifyListeners();
  }

  void selectDate(String date) {
    _selectedDate = date;
    _selectedTime = times.isNotEmpty ? times[0] : "";
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

  void selectPaymentMethod(String method) {
    _selectedPayment = method;
    notifyListeners();
  }

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
        onTimeoutCallback();
        return;
      }
      _remainingSeconds--;
      notifyListeners();
    });
  }

  Booking completePayment() {
    _timer?.cancel();
    return Booking(
      movieTitle: _activeMovie!.title,
      cinema: _selectedCinema,
      date: _selectedDate,
      time: _selectedTime,
      seats: _selectedSeats.map((s) => s.id).toList(),
      totalPrice: totalPrice.toDouble(),
      status: 'Success',
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
