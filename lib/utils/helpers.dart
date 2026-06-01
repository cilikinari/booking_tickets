class AppHelpers {
  // Fungsi global untuk memformat angka ke format mata uang Rupiah (cth: 150000 -> 150.000)
  static String formatNumber(num amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]}.',
    );
  }
}