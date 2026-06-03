import 'package:flutter/material.dart';
import '../../data/models/movie.dart';

class MovieSection extends StatelessWidget {
  final String title; // Tambahkan parameter title
  final List<Movie> movies;
  final bool isWide;
  final Function(Movie)? onMovieTap;

  const MovieSection({
    super.key,
    required this.title, // Wajib diisi saat memanggil
    required this.movies,
    required this.isWide,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul section yang dipindahkan dari HomeScreen
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12), // Jarak antara judul dan list film
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: movies.map((movie) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: MovieCard(
                  movie: movie,
                  isWide: isWide,
                  onTap: () {
                    if (onMovieTap != null) {
                      onMovieTap!(movie);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isWide;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isWide,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              movie.imagePath,
              fit: BoxFit.cover,
              height: isWide ? 200 : 220,
              width: isWide ? 350 : 150,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: isWide ? 350 : 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Container(
                    constraints: BoxConstraints(minHeight: isWide ? 40 : 35),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      movie.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isWide ? 20 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${isWide ? '2025' : '2026'} • ${movie.genre}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
