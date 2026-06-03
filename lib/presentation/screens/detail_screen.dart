import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/movie_data.dart';
import '../../utils/constants.dart';
import 'seat_screen.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;
  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String selectedCinema = MovieData.cinemas[0];
  String selectedDate = MovieData.dates[0];
  String selectedTime = MovieData.times[2];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth > 900; // Adjusted for better desktop feel
    final double horizontalPadding = isWide ? AppConstants.padding : 16.0;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BackButton(
                    color: Colors.white,
                  ), // Menggunakan bawaan Flutter dengan warna putih
                  const SizedBox(height: 16),
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width:
                              380, // Slightly larger for better balance on desktop
                          child: _buildPosterSection(),
                        ),
                        const SizedBox(width: 48),
                        Expanded(child: _buildDetailsSection(isWide)),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SizedBox(
                            width:
                                screenWidth * 0.75, // Impactful but still neat
                            child: _buildPosterSection(),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildDetailsSection(isWide),
                      ],
                    ),
                  const SizedBox(height: 32),
                  _buildBookButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPosterSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: Image.asset(
            widget.movie.imagePath,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(height: 20),
      Text(
        widget.movie.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22, // Reduced from 26
          fontWeight: FontWeight.bold,
          letterSpacing: -0.2,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        widget.movie.genre,
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 14, // Reduced from 16
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );

  Widget _buildDetailsSection(bool isWide) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildBadgesAndPrice(isWide),
      const SizedBox(height: 20),
      _sectionCard(
        title: "Description",
        child: Text(
          widget.movie.description,
          style: const TextStyle(
            color: AppConstants.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
      _sectionCard(title: "Choose Cinema", child: _buildCinemaDropdown()),
      _sectionCard(title: "Date & Time", child: _buildDateTimeSelectors()),
    ],
  );

  String _formatIDR(double amount) {
    String price = amount.toInt().toString();
    String formatted = "";
    int count = 0;
    for (int i = price.length - 1; i >= 0; i--) {
      formatted = price[i] + formatted;
      count++;
      if (count == 3 && i != 0) {
        formatted = "." + formatted;
        count = 0;
      }
    }
    return "Rp$formatted";
  }

  Widget _buildBadgesAndPrice(bool isWide) => SizedBox(
    width: double.infinity,
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _pill(widget.movie.ageRating, Icons.lock),
            _pill(widget.movie.duration, Icons.access_time),
            _pill(widget.movie.year, Icons.calendar_today),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _formatIDR(widget.movie.price),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildBookButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SeatScreen(
              movie: widget.movie,
              cinema: selectedCinema,
              date: selectedDate,
              time: selectedTime,
              ticketPrice: widget.movie.price.toInt(),
            ),
          ),
        );
      },
      child: const Text(
        "Book Now",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );

  Widget _buildCinemaDropdown() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: AppConstants.inputColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white10),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        dropdownColor: AppConstants.cardColor,
        value: selectedCinema,
        items: MovieData.cinemas
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(color: Colors.white)),
              ),
            )
            .toList(),
        onChanged: (v) {
          if (v != null) {
            setState(() => selectedCinema = v);
          }
        },
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
      ),
    ),
  );

  Widget _buildDateTimeSelectors() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _selectHeader("Date"),
      _selectList(
        MovieData.dates,
        selectedDate,
        (v) => setState(() => selectedDate = v),
      ),
      const SizedBox(height: 20),
      _selectHeader("Time"),
      _selectList(
        MovieData.times,
        selectedTime,
        (v) => setState(() => selectedTime = v),
      ),
    ],
  );

  Widget _selectHeader(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      t,
      style: const TextStyle(
        color: AppConstants.textSecondary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _selectList(List<String> items, String sel, Function(String) onSel) =>
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: items.map((i) {
          final isSel = i == sel;
          return GestureDetector(
            onTap: () => onSel(i),
            child: AnimatedContainer(
              duration: AppConstants.fastAnimation,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSel
                    ? AppConstants.primaryColor
                    : AppConstants.inputColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSel ? Colors.transparent : Colors.white10,
                ),
              ),
              child: Text(
                i,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      );

  Widget _sectionCard({required String title, required Widget child}) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppConstants.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      );

  Widget _pill(String t, IconData i) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: AppConstants.inputColor,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(i, color: AppConstants.textSecondary, size: 14),
        const SizedBox(width: 8),
        Text(
          t,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
