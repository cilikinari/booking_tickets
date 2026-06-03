class AppHelpers {
  // Fungsi 1: Format angka biasa (cth: 150000 -> 140.000)
  static String formatNumber(num amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');
  }

  // Fungsi 2: Format langsung jadi Rupiah (cth: 150000 -> Rp150.000)
  static String formatIDR(num amount) {
    return "Rp${formatNumber(amount)}";
  }
}