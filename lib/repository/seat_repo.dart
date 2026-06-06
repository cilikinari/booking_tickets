import '../data/datasources/seat_services.dart';
import '../data/models/seat.dart';

class SeatRepository {
  Future<List<Seat>> getSeatsBySchedule(int scheduleId, String token) async {
    return await SeatServices.getSeatsBySchedule(scheduleId, token);
  }
}