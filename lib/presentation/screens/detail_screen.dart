import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/movie.dart';
import '../../domain/providers/booking_provider.dart';
import '../../utils/constants.dart';
import '../widgets/detail_poster.dart';
import '../widgets/detail_info.dart';
import '../widgets/detail_selection.dart';
import '../widgets/book_button.dart';

class DetailScreen extends StatelessWidget {
  final Movie movie;
  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bookingProvider.activeMovie?.title != movie.title) {
        bookingProvider.startBooking(movie);
      }
    });

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth > 900;
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
                  const BackButton(color: Colors.white),
                  const SizedBox(height: 16),

                  // Layout Responsive
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 380, child: MoviePoster(movie: movie)),
                        const SizedBox(width: 48),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MovieInfoAndDescription(movie: movie),
                              const SizedBox(height: 16),
                              BookingSelection(provider: bookingProvider),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SizedBox(
                            width: screenWidth * 0.75,
                            child: MoviePoster(movie: movie),
                          ),
                        ),
                        const SizedBox(height: 28),
                        MovieInfoAndDescription(movie: movie),
                        const SizedBox(height: 16),
                        BookingSelection(provider: bookingProvider),
                      ],
                    ),

                  const SizedBox(height: 32),
                  BookButton(scheduleId: bookingProvider.selectedScheduleId), //ini ngambil data kecil schedule id buat nanti di invoice
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
