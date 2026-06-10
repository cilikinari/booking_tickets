import 'dart:convert';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  bool _isConnecting = false;
  
  // 🔥 StreamController untuk mengirim data secara aman ke PaymentScreen (UI)
  final StreamController<Map<String, dynamic>> _paymentStreamController = 
      StreamController<Map<String, dynamic>>.broadcast();

  // Getter agar UI bisa mendengarkan aliran data ini
  Stream<Map<String, dynamic>> get paymentStream => _paymentStreamController.stream;

  // 💡 BuildContext sudah dihapus dari parameter!
  void connectToServer(String currentUserId) {
    if (_isConnecting) return;
    _isConnecting = true;

    // 💡 TIPS EMULATOR ANDROID: ganti 'localhost' jadi '10.0.2.2'. 
    // Kalau pakai HP asli/iOS tetap 'localhost' atau 'IP Laptop'.
    final String wsUrl = 'ws://localhost:3000/ws/notifications/$currentUserId'; 

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      print('🔌 [WS] Mencoba terhubung ke $wsUrl');

      _channel!.stream.listen(
        (message) {
          print('🔔 [WS] Data masuk: $message');
          try {
            final Map<String, dynamic> data = jsonDecode(message);

            // 1. Cek tipe notifikasinya
            if (data['type'] == 'PAYMENT_NOTIFICATION') {
              
              // 2. CRITICAL FILTER: Pastikan user_id dari server SAMA dengan user yang lagi login!
              if (data['user_id'] == currentUserId) {
                // 🔥 Teruskan data ke Stream agar ditangkap oleh PaymentScreen
                _paymentStreamController.add(data);
              }
            }
          } catch (e) {
            print('❌ [WS] Gagal parse data json: $e');
          }
        },
        onError: (error) {
          print('❌ [WS] Error: $error');
          _isConnecting = false;
          _reconnect(currentUserId); // Auto reconnect kalau error
        },
        onDone: () {
          print('❌ [WS] Koneksi terputus dari server.');
          _isConnecting = false;
          _reconnect(currentUserId); // Auto reconnect kalau server restart
        },
      );
    } catch (e) {
      _isConnecting = false;
      print('❌ [WS] Gagal inisialisasi koneksi: $e');
    }
  }

  // Fungsi auto-reconnect cerdas tiap 5 detik jika koneksi drop
  void _reconnect(String currentUserId) {
    Future.delayed(const Duration(seconds: 5), () {
      print('🔄 [WS] Mencoba menyambungkan ulang koneksi WebSocket...');
      connectToServer(currentUserId);
    });
  }

  // Panggil ini saat user keluar dari halaman pembayaran / logout
  void disconnect() {
    _channel?.sink.close();
    _isConnecting = false;
    print('🔌 [WS] Koneksi ditutup secara manual.');
  }

  // Panggil jika service benar-benar mau dimatikan total
  void dispose() {
    _paymentStreamController.close();
    disconnect();
  }
}