import 'package:flutter/material.dart';
import '../../repository/seat_repo.dart';
import '../../data/models/seat.dart';

class SeatProvider extends ChangeNotifier {
  final SeatRepository _seatRepo = SeatRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Seat> _seats = [];
  List<Seat> get seats => _seats;

  // Menyimpan kursi yang sedang diklik/dipilih oleh user
  List<Seat> _selectedSeats = [];
  List<Seat> get selectedSeats => _selectedSeats;

  // Fungsi ambil data dari API
  Future<void> fetchSeats(int scheduleId, String token) async {
    _isLoading = true;
    _selectedSeats.clear(); // Bersihkan pilihan sebelumnya
    notifyListeners();

    try {
      _seats = await _seatRepo.getSeatsBySchedule(scheduleId, token);
    } catch (e) {
      print('Error fetch seats: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logika saat user mengklik kotak kursi di layar
  void toggleSeat(Seat seat) {
    // Kalau kursi udah dibeli orang, cuekin aja kliknya
    if (seat.status == SeatStatus.booked) return;

    if (_selectedSeats.contains(seat)) {
      // Kalau sebelumnya sudah diklik, berarti user mau batalin pilihannya
      _selectedSeats.remove(seat);
    } else {
      // Batasi maksimal pembelian tiket (opsional, misal max 5)
      if (_selectedSeats.length < 5) {
        _selectedSeats.add(seat);
      } else {
        // Bisa trigger Toast/Snackbar di UI nanti kalau lebih dari 5
        print('Maksimal pilih 5 kursi!'); 
      }
    }
    notifyListeners(); // Refresh warna UI
  }
}