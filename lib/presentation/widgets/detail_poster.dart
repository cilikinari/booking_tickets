import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../utils/constants.dart';

class MoviePoster extends StatelessWidget {
  final Movie movie;

  const MoviePoster({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final String genreText = movie.genres.isNotEmpty
        ? movie.genres.map((g) => g.name).join(', ')
        : 'No Genre';

    // 🟢 SINKRONISASI JALUR URL (Sesuai dengan path public di backend Go)
    String cleanedPosterUrl = movie.posterUrl;
    if (!cleanedPosterUrl.startsWith('http')) {
      // Hilangkan slash di awal jika ada, lalu gabung dengan localhost
      if (cleanedPosterUrl.startsWith('/')) {
        cleanedPosterUrl = cleanedPosterUrl.substring(1);
      }
      cleanedPosterUrl = 'http://localhost:3000/$cleanedPosterUrl';
    }

    // 🟢 DIBUNGKUS CONSTRAINEDBOX AGAR TIDAK OVERFLOW (Garis zebra)
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 350),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: movie.posterUrl.isNotEmpty
                  ? Image.network(
                      cleanedPosterUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[900],
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.red,
                            size: 40,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.movie,
                        color: Colors.white30,
                        size: 40,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            movie.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            genreText,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}