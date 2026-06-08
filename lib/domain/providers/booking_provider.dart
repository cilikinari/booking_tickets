import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
import '../../data/models/movie.dart';
import '../../data/models/seat.dart';
import '../../data/models/booking.dart';
import '../../data/models/schedule.dart';
import '../../data/models/studio.dart';
import '../../data/models/cinema.dart';
import '../../repository/booking_repo.dart';
import '../../data/datasources/auth_services.dart'; 

class BookingProvider extends ChangeNotifier {
  final BookingRepository _repository = BookingRepository();

  List<Schedule> _allSchedules = [];
  List<Studio> _allStudios = [];
  List<Cinema> _allCinemas = [];

  bool _isLoading = false;
  String _errorMessage = '';

  Movie? _activeMovie;
  String _selectedCinema = '';
  String _selectedDate = '';
  String _selectedTime = '';
  List<Seat> _selectedSeats = [];
  String _selectedPayment = '';
  int _remainingSeconds = 300;
  Timer? _timer;
  bool _isTimeout = false;
  String? currentBookingId;

  Movie? get activeMovie => _activeMovie;
  List<Seat> get selectedSeats => _selectedSeats;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedPayment => _selectedPayment;
  bool get isTimeout => _isTimeout;
  bool get canPay => _selectedPayment.isNotEmpty;
  int get totalPrice => _selectedSeats.length * ticketPrice;
  String get selectedCinema => _selectedCinema;
  String get selectedDate => _selectedDate;
  String get selectedTime => _selectedTime;

  String get formattedCountdown {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get selectedLabels {
    if (_selectedSeats.isEmpty) return 'No seat selected';
    return _selectedSeats.map((s) => s.seatNumber).join(', ');
  }

  int get selectedScheduleId {
    try {
      return _findCurrentSchedule().id;
    } catch (_) {
      return -1;
    }
  }

  int get ticketPrice {
    if (_allSchedules.isEmpty || _selectedCinema.isEmpty) return 0;
    try {
      return _findCurrentSchedule().price;
    } catch (_) {
      return 0;
    }
  }

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
        .where((s) =>
            s.movieId.toString() == _activeMovie?.id.toString() &&
            _getCombinedName(s.studioId) == _selectedCinema)
        .map((s) => s.date)
        .toSet()
        .toList();
  }

  List<String> get times {
    if (_selectedCinema.isEmpty || _selectedDate.isEmpty) return [];
    return _allSchedules
        .where((s) =>
            s.movieId.toString() == _activeMovie?.id.toString() &&
            s.date == _selectedDate &&
            _getCombinedName(s.studioId) == _selectedCinema)
        .map((s) => s.time)
        .toSet()
        .toList();
  }

  String _getCombinedName(int studioId) {
    final studio = _allStudios.firstWhere(
      (st) => st.id == studioId,
      orElse: () => Studio(id: 0, cinemaId: 0, studioName: ''),
    );
    final cinema = _allCinemas.firstWhere(
      (c) => c.id == studio.cinemaId,
      orElse: () => Cinema(id: 0, name: ''),
    );
    return cinema.name.isEmpty
        ? studio.studioName
        : '${cinema.name} - ${studio.studioName}';
  }

  Schedule _findCurrentSchedule() {
    return _allSchedules.firstWhere((s) =>
        s.movieId.toString() == _activeMovie?.id.toString() &&
        s.date == _selectedDate &&
        s.time == _selectedTime &&
        _getCombinedName(s.studioId) == _selectedCinema);
  }

  Map<String, String> _authHeaders(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  void selectCinema(String cinema) {
    _selectedCinema = cinema;
    _selectedDate = dates.isNotEmpty ? dates[0] : '';
    _selectedTime = times.isNotEmpty ? times[0] : '';
    notifyListeners();
  }

  void selectDate(String date) {
    _selectedDate = date;
    _selectedTime = times.isNotEmpty ? times[0] : '';
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

  void stopTimer() => _timer?.cancel();

  Future<void> startBooking(Movie movie) async {
    _activeMovie = movie;
    _selectedCinema = '';
    _selectedDate = '';
    _selectedTime = '';
    _selectedSeats = [];
    _selectedPayment = '';
    _isTimeout = false;
    _remainingSeconds = 300;
    currentBookingId = null;
    _timer?.cancel();
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await Future.wait([
        _repository.getSchedules().then((v) => _allSchedules = v),
        _repository.getStudios().then((v) => _allStudios = v),
        _repository.getCinemas().then((v) => _allCinemas = v),
      ]);

      if (cinemas.isNotEmpty) {
        _selectedCinema = cinemas[0];
        if (dates.isNotEmpty) {
          _selectedDate = dates[0];
          if (times.isNotEmpty) _selectedTime = times[0];
        }
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startPaymentTimer(VoidCallback onTimeout) {
    _timer?.cancel();
    _remainingSeconds = 300;
    _isTimeout = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        _remainingSeconds = 0;
        _isTimeout = true;
        timer.cancel();
        notifyListeners();
        onTimeout();
        return;
      }
      _remainingSeconds--;
      notifyListeners();
    });
  }

  Future<void> lockSeats(String token) async {
    final seatIds = _selectedSeats.map((s) => int.parse(s.id.toString())).toList();
    final scheduleId = selectedScheduleId;

    final response = await http.post(
      Uri.parse('${AuthServices.baseUrl}/booking'),
      headers: _authHeaders(token),
      body: jsonEncode({
        'schedule_id': scheduleId,
        'seat_ids': seatIds,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal mengunci kursi');
    }

    currentBookingId = jsonDecode(response.body)['id'] as String;
  }

  Future<void> processPayment({
    required String bookingId,
    required String paymentMethod,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('${AuthServices.baseUrl}/payment'),
      headers: _authHeaders(token),
      body: jsonEncode({
        'booking_id': bookingId,
        'payment_method': paymentMethod,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal memproses pembayaran');
    }
  }

  Booking completePayment() {
    _timer?.cancel();
    return Booking(
      movieTitle: _activeMovie!.title,
      cinema: _selectedCinema,
      date: _selectedDate,
      time: _selectedTime,
      seats: _selectedSeats.map((s) => s.seatNumber).toList(),
      totalPrice: totalPrice.toDouble(),
      status: 'Success',
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}