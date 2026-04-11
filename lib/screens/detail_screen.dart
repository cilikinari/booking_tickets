import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/bottom_nav.dart';
import '../data/movie_data.dart';
import '../utils/constants.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;
  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String selectedDate = MovieData.dates[0], selectedTime = MovieData.times[2];

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 700;
    final poster = _buildHeroPoster(context), info = _buildMovieInfo();
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      bottomNavigationBar: CustomBottomNav(currentIndex: 0, onTap: (index) {}),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                children: [
                  isWide
                      ? Row(
                          children: [
                            Expanded(flex: 2, child: poster),
                            const SizedBox(width: 32),
                            Expanded(flex: 3, child: info),
                          ],
                        )
                      : Column(
                          children: [poster, const SizedBox(height: 16), info],
                        ),
                  _buildBookingOptions(isWide),
                  const SizedBox(height: 30),
                  _buildBookButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () => print(
        "Booking ${widget.movie.title} on $selectedDate at $selectedTime",
      ),
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

  Widget _buildHeroPoster(BuildContext context) => Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Image.asset(
          widget.movie.imagePath,
          width: double.infinity,
          height: 400,
          fit: BoxFit.cover,
        ),
      ),
      Container(
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.9), Colors.transparent],
          ),
        ),
      ),
      Positioned(
        top: 10,
        left: 10,
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const CircleAvatar(
            backgroundColor: Colors.black26,
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        left: 20,
        right: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.movie.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.movie.genre,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _buildMovieInfo() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 20),
      Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _pill(widget.movie.ageRating, Icons.lock),
                _pill(widget.movie.duration, Icons.access_time),
                _pill(widget.movie.year, Icons.calendar_today),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${AppConstants.defaultCurrency}${widget.movie.price}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),
      _sectionCard(
        title: "Description",
        child: Text(
          widget.movie.description,
          style: const TextStyle(
            color: AppConstants.textSecondary,
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ),
    ],
  );

  Widget _buildBookingOptions(bool isWide) {
    final cinema = _sectionCard(
      title: "Choose Cinema",
      child: _buildCinemaDropdown(),
    );
    final dateTime = _sectionCard(
      title: "Date & Time",
      child: _buildDateTimeSelectors(),
    );
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: cinema),
                const SizedBox(width: 16),
                Expanded(child: dateTime),
              ],
            )
          : Column(children: [cinema, const SizedBox(height: 16), dateTime]),
    );
  }

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
        value: MovieData.cinemas[0],
        items: MovieData.cinemas
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(color: Colors.white)),
              ),
            )
            .toList(),
        onChanged: (v) {},
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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppConstants.cardColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      );

  Widget _pill(String t, IconData i) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: AppConstants.inputColor,
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      border: Border.all(color: Colors.white10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(i, color: AppConstants.textSecondary, size: 14),
        const SizedBox(width: 6),
        Text(t, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    ),
  );
}
