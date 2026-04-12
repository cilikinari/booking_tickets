import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../data/movie_data.dart';
import '../utils/constants.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _filteredMovies = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredMovies = [];
      });
      return;
    }

    final String lowerQuery = query.toLowerCase();
    final List<Movie> allMovies = [
      ...MovieData.topMovies,
      ...MovieData.nowPlaying,
    ];
    final List<Movie> movieResults = allMovies
        .where(
          (movie) =>
              movie.title.toLowerCase().contains(lowerQuery) ||
              movie.genre.toLowerCase().contains(lowerQuery),
        )
        .toSet()
        .toList();

    setState(() {
      _isSearching = true;
      _filteredMovies = movieResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
              _buildSearchInput(),
              const SizedBox(height: 20),
              Expanded(
                child: _isSearching ? _buildResults() : _buildInitialState(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchInput() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.search, color: Colors.grey, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: "Search movies or genres...",
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged("");
                setState(() {});
              },
            ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_rounded, size: 60, color: Colors.grey[800]),
          const SizedBox(height: 16),
          Text(
            "Find your favorite movies or genres",
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_filteredMovies.isEmpty) {
      return const Center(
        child: Text("No results found", style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const Text(
          "Movies",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final int crossAxisCount = width >= 1200
                ? 6
                : width >= 1000
                ? 5
                : width >= 700
                ? 4
                : width >= 500
                ? 3
                : 2;
            final double cardRatio = width < 500 ? 0.55 : 0.5;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                childAspectRatio: cardRatio,
              ),
              itemCount: _filteredMovies.length,
              itemBuilder: (context, index) {
                return _buildMovieCard(_filteredMovies[index]);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(movie: movie)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                movie.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            movie.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            movie.genre,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
