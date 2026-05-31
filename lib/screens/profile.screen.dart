import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/bottom_nav.dart';
import 'home_screen.dart';
import 'history_screen.dart';
// Pastikan path import ini disesuaikan dengan struktur foldermu
import 'home_unauth_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Fungsi untuk memunculkan Pop-Up Logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1E1E1E), // Warna kotak disamakan
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.logout,
                  color: AppConstants.primaryColor, // Pakai konstanta warnamu
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Are you logging out?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "You'll need to sign in again to continue booking tickets and accessing your reservations.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Tombol Log Out di pop-up
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Navigasi menghapus semua halaman dan kembali ke Home Awal
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeUnauthScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Tombol Cancel di pop-up
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF333333),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Tutup pop-up saja
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        title: const Text(
          'My Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Profile Image
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 90,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Name
                  const Text(
                    'Cili Kinari Ariyuda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Info Container
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131313),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Phone', '088987273947'),
                        const Divider(color: Colors.white10, height: 48),
                        _buildInfoRow('Email', 'cilikinari@gmail.com'),
                        const Divider(color: Colors.white10, height: 48),
                        _buildLogOutRow(context), // Lempar context ke sini
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Tambahkan BuildContext di parameter
  Widget _buildLogOutRow(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // Panggil fungsi pop-up saat diklik
            _showLogoutDialog(context);
          },
          child: const Text(
            'Log Out',
            style: TextStyle(
              color: AppConstants.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}