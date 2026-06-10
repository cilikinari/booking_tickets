import 'dart:convert';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'auth_services.dart'; 

class WebSocketService {
  WebSocketChannel? _channel;
  bool _isConnecting = false;
  
  // 🔥 StreamController untuk mengirim data secara aman ke PaymentScreen (UI)
  final StreamController<Map<String, dynamic>> _paymentStreamController = 
      StreamController<Map<String, dynamic>>.broadcast();

  // Getter agar UI bisa mendengarkan aliran data ini
  Stream<Map<String, dynamic>> get paymentStream => _paymentStreamController.stream;

  void connectToServer(String currentUserId) {
    if (_isConnecting) return;
    _isConnecting = true;

    final String rawUrl = AuthServices.baseUrl.replaceAll('http://', 'ws://').replaceAll('/api/v1', '');
    final String wsUrl = '$rawUrl/ws/notifications/$currentUserId';

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      print('🔌 [WS] Mencoba terhubung ke $wsUrl');

      _channel!.stream.listen(
        (message) {
          print('🔔 [WS] Data masuk: $message');
          try {
            final Map<String, dynamic> data = jsonDecode(message);

            if (data['type'] == 'PAYMENT_NOTIFICATION' || data['type'] == 'BOOKING_TIMEOUT') {
              
              if (data['user_id'] == currentUserId) {
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
          _reconnect(currentUserId);
        },
        onDone: () {
          print('❌ [WS] Koneksi terputus dari server.');
          _isConnecting = false;
          _reconnect(currentUserId);
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