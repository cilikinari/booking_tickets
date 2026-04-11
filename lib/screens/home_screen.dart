import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../data/movie_data.dart';
import '../utils/constants.dart';
import 'detail_screen.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _MovieSection(
                    title: "Top Movies",
                    movies: MovieData.topMovies,
                    isGrid: true,
                  ),
                  const SizedBox(height: 24),
                  _MovieSection(
                    title: "Now Playing",
                    movies: MovieData.nowPlaying,
                    isGrid: false,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppConstants.primaryColor),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: const Row(
            children: [
              Text(
                "Tangerang",
                style: TextStyle(color: AppConstants.textPrimary),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppConstants.textPrimary,
                size: 18,
              ),
            ],
          ),
        ),
        const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: const TextField(
        style: TextStyle(color: AppConstants.textPrimary),
        decoration: InputDecoration(
          hintText: "Search for movies or city",
          hintStyle: TextStyle(color: AppConstants.textMuted),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: AppConstants.textMuted),
        ),
      ),
    );
  }
}

class _MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final bool isGrid;

  const _MovieSection({
    required this.title,
    required this.movies,
    required this.isGrid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        isGrid ? _buildGrid(context) : _buildList(context),
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = (width > 1200)
        ? 6
        : (width > 1000)
        ? 5
        : (width > 800)
        ? 4
        : (width > 600)
        ? 3
        : (width > 400)
        ? 2
        : 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: movies.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (_, i) => _MovieCard(movie: movies[i], isLarge: true),
    );
  }

  Widget _buildList(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: movies
            .map(
              (m) => Padding(
                padding: const EdgeInsets.only(right: 22),
                child: SizedBox(
                  width: 140,
                  child: _MovieCard(movie: m, isLarge: false),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isLarge;

  const _MovieCard({required this.movie, required this.isLarge});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(movie: movie)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isLarge ? 1 : 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isLarge ? 10 : 7),
              child: Image.asset(
                movie.imagePath,
                fit: BoxFit.cover,
                height: isLarge ? null : 230,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: isLarge ? 18 : 15,
              fontWeight: isLarge ? FontWeight.bold : FontWeight.w600,
            ),
          ),
          Text(
            movie.genre,
            style: TextStyle(color: Colors.grey, fontSize: isLarge ? 14 : 11),
          ),
        ],
      ),
    );
  }
}
