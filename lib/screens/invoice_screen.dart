import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../utils/constants.dart';

class InvoiceScreen extends StatelessWidget {
  final Booking booking;

  const InvoiceScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'E-Ticket',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        // KUNCI RESPONSIVE WEB & MOBILE: Center & ConstrainedBox
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 450, // Lebar maksimal tiket agar tidak melar di Web
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- KARTU TIKET UTAMA ---
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // 1. BAGIAN ATAS (Header Merah)
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: AppConstants.primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              Text(
                                booking.movieTitle.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    booking.cinema,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // 2. EFEK SOBEKAN TIKET (Responsive)
                        Container(
                          color: Colors.white,
                          child: Row(
                            children: [
                              const SizedBox(
                                height: 24,
                                width: 12,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    color: AppConstants
                                        .backgroundColor, // Sesuai warna background luar
                                  ),
                                ),
                              ),
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Flex(
                                      direction: Axis.horizontal,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(
                                        (constraints.constrainWidth() / 12)
                                            .floor(),
                                        (index) => const SizedBox(
                                          width: 6,
                                          height: 2,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                                width: 12,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                    color: AppConstants.backgroundColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 3. BAGIAN TENGAH (Detail Info)
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildInfoItem(
                                    'Date',
                                    booking.date,
                                    CrossAxisAlignment.start,
                                  ),
                                  _buildInfoItem(
                                    'Time',
                                    booking.time,
                                    CrossAxisAlignment.end,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildInfoItem(
                                    'Seats',
                                    booking.seats.join(', '),
                                    CrossAxisAlignment.start,
                                  ),
                                  _buildInfoItem(
                                    'Order ID',
                                    '#CM-98231A',
                                    CrossAxisAlignment.end,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              // QR CODE
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.qr_code_2,
                                      size: 100,
                                      color: Colors.black87,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Scan at counter',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 4. BAGIAN BAWAH (Total)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Payment',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Rp ${booking.totalPrice.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- TOMBOL KEMBALI ---
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      child: const Text(
                        'Back to Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    CrossAxisAlignment alignment,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow
                .ellipsis, // Menghindari teks kepanjangan bikin error
          ),
        ],
      ),
    );
  }
}
