import '../data/datasources/booking_services.dart';
import '../data/models/schedule.dart';
import '../data/models/studio.dart';
import '../data/models/cinema.dart';

class BookingRepository {
  final BookingService _bookingService = BookingService();

  Future<List<Schedule>> getSchedules() => _bookingService.fetchAllSchedules();
  //ini dipake buat nanti di invoice, jadi ngambil berdasarkan id
  Future<Schedule> getScheduleById(int id) => _bookingService.fetchScheduleById(id);
  
  Future<List<Studio>> getStudios() => _bookingService.fetchAllStudios();

  Future<List<Cinema>> getCinemas() => _bookingService.fetchAllCinemas();
}
// Repository ini bertugas untuk menghubungkan antara data source (BookingService) dengan provider (BookingProvider).
// Disini kita bisa menambahkan fungsi-fungsi yang dibutuhkan untuk melakukan booking. 