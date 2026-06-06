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

//ini aturan getter buat ui baca data dari provider, jadi ui gak perlu tau proses dapetinnya dari mana, cukup panggil getter ini aja.
// ini getter biasa buat data yg udah siap pakai seperti selected
  Movie? get activeMovie => _activeMovie;
  List<Seat> get selectedSeats => _selectedSeats;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedPayment => _selectedPayment;
  int get remainingSeconds => _remainingSeconds;
  bool get isTimeout => _isTimeout;
  bool get canPay => _selectedPayment.isNotEmpty;
  int get totalPrice => _selectedSeats.length * ticketPrice;
  String get selectedCinema => _selectedCinema;
  String get selectedDate => _selectedDate;
  String get selectedTime => _selectedTime;

//combined nama cinema and studio
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
  // computed getter, data harus dihitung dulu baru dikasih ke user, contohnya untuk get cinema dari movie yg aktive agar sesuai dengan movie pilihan user, 
  //maka cinema harus dihitung dulu baru dikasih ke user, begitu juga dengan date, jika date tidak sesuai dengan movie dan 
  //cinema pilihan user, maka date tidak muncul, begitu juga dengan time, jika time tidak sesuai dengan movie, cinema, dan date pilihan user, 
  //maka time tidak muncul, begitu juga dengan ticket price, jika ticket price tidak sesuai dengan movie, cinema, date, dan time pilihan user, maka ticket price tidak muncul
  // ========================================================

//ini buat ambil detail cinema dari movie active biar sesuai dengan yg diklik user
  List<String> get cinemas {
    return _allSchedules
        .where((s) => s.movieId.toString() == _activeMovie?.id.toString())
        .map((s) => _getCombinedName(s.studioId))
        .toSet()
        .toList();
  }

//ini buat ngasih date, movie tidak sesuai yg dipilih user, maka jadwalnya tidak muncul, begitu juga dengan cinema, jika cinema tidak sesuai dengan yg dipilih user, maka jadwalnya tidak muncul
// jika sesuai maka akan munculin date yang tersedia untuk jadwal itu
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

//
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

//logika untuk update pilihan user, misal user pilih cinema, maka date dan time harus di reset 
//karena bisa jadi date dan time sebelumnya tidak sesuai dengan cinema yang baru dipilih user, 
//? => adalah represent dari kondisi if. 

  void selectCinema(String cinema) {
    _selectedCinema = cinema;
    _selectedDate = dates.isNotEmpty ? dates[0] : ""; //artinya data yg dipilih akan masuk ke _selectedDate, tapi jika data tidak ada maka _selectedDate akan diisi dengan string kosong
    _selectedTime = times.isNotEmpty ? times[0] : "";
    notifyListeners(); //ngasitau ui kalo ada update data
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

// Logika untuk timer pembayaran, jika waktu habis maka booking akan dibatalkan dan data yang sudah dipilih akan di reset, 
//dan user harus memulai booking dari awal lagi jika ingin melakukan booking
  void startPaymentTimer(VoidCallback onTimeoutCallback) {
    _timer?.cancel();
    _remainingSeconds = 100;
    _isTimeout = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        _remainingSeconds = 0;
        _isTimeout = true; //tanda waktu habis agar tidak menghitung mundur lagi
        _timer?.cancel();
        notifyListeners();
        onTimeoutCallback(); //pop up dialog timeout akan muncul setelah waktu habis
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
