import 'package:flutter/material.dart';
import '../models/movie.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Movie> topMovies = [
    Movie(title: "Scream 7", imagePath: "assets/image/movies/scream.png", genre: "Horror", duration: "1h 54m", year: "2026", ageRating: "16+", price: 60000, description: ""),
    Movie(title: "David", imagePath: "assets/image/movies/david.png", genre: "Drama", duration: "2h 10m", year: "2026", ageRating: "13+", price: 60000, description: ""),
    Movie(title: "Bride", imagePath: "assets/image/movies/bride.png", genre: "Horror", duration: "1h 45m", year: "2026", ageRating: "17+", price: 60000, description: ""),
    Movie(title: "Ghost Train", imagePath: "assets/image/movies/ghosttrain.png", genre: "Thriller", duration: "1h 50m", year: "2026", ageRating: "13+", price: 60000, description: ""),
    Movie(title: "Ugly Sister", imagePath: "assets/image/movies/uglysister.png", genre: "Drama", duration: "2h 00m", year: "2026", ageRating: "13+", price: 60000, description: ""),
    Movie(title: "Send Help", imagePath: "assets/image/movies/sendhelp.png", genre: "Comedy", duration: "1h 40m", year: "2026", ageRating: "13+", price: 60000, description: ""),
    Movie(title: "Wild Robot", imagePath: "assets/image/movies/wildrobot.png", genre: "Animation", duration: "1h 40m", year: "2026", ageRating: "SU", price: 60000, description: ""),
  ];

  final List<Movie> nowPlaying = [
    Movie(title: "Ghost In The Cell", imagePath: "assets/image/movies/gitc.png", genre: "Horror", duration: "1h 50m", year: "2026", ageRating: "17+", price: 60000, description: ""),
    Movie(title: "Tinggal Meninggal", imagePath: "assets/image/movies/tinggalmeninggal.png", genre: "Horror", duration: "1h 30m", year: "2026", ageRating: "13+", price: 60000, description: ""),
    Movie(title: "Esok Tanpa Ibu", imagePath: "assets/image/movies/tnpaibu.png", genre: "Drama", duration: "2h 00m", year: "2026", ageRating: "SU", price: 60000, description: ""),
    Movie(title: "Perayaan Mati Rasa", imagePath: "assets/image/movies/mati.png", genre: "Drama", duration: "2h 10m", year: "2026", ageRating: "17+", price: 60000, description: ""),
    Movie(title: "28 Years: The Bone Temple", imagePath: "assets/image/movies/28.png", genre: "Horror", duration: "2h 00m", year: "2026", ageRating: "17+", price: 60000, description: ""),
    Movie(title: "Primate", imagePath: "assets/image/movies/primate.png", genre: "Horror", duration: "1h 50m", year: "2026", ageRating: "17+", price: 60000, description: ""),
    Movie(title: "The Housemaid", imagePath: "assets/image/movies/housemaid.png", genre: "Horror, Drama", duration: "1h 30m", year: "2026", ageRating: "13+", price: 60000, description: ""),
    Movie(title: "Good Boy", imagePath: "assets/image/movies/goodboy.png", genre: "Drama, Mystery", duration: "2h 00m", year: "2026", ageRating: "SU", price: 60000, description: ""),
    Movie(title: "Perang Kota", imagePath: "assets/image/movies/perangkota.png", genre: "Drama, Mystery", duration: "2h 10m", year: "2026", ageRating: "17+", price: 60000, description: ""),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildTopMovies(context), // 🔥 pakai context
              const SizedBox(height: 24),
              _buildNowPlaying(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFFF3131)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Text("Tangerang", style: TextStyle(color: Colors.white)),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
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

  // ================= SEARCH =================
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search for movies or city",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }

  // ================= TOP MOVIES (FIXED RESPONSIVE) =================
  Widget _buildTopMovies(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = 2;

    if (width > 1000) {
      crossAxisCount = 5;
    } else if (width > 800) {
      crossAxisCount = 4;
    } else if (width > 600) {
      crossAxisCount = 3;
    } else if (width > 400) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1; // 🔥 ini bikin turun
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Top Movies",
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topMovies.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (_, i) => _topMovieCard(topMovies[i]),
        ),
      ],
    );
  }

  Widget _topMovieCard(Movie movie) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
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
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            movie.genre,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ================= NOW PLAYING =================
  Widget _buildNowPlaying() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Now Playing",
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: nowPlaying.map((movie) {
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 22),
                child: _nowPlayingCard(movie),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _nowPlayingCard(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Image.asset(
            movie.imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 230,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          movie.title,
          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        Text(
          movie.genre,
          style: const TextStyle(color: Colors.grey, fontSize: 11),
        ),
      ],
    );
  }

  // ================= NAVBAR =================
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF1A1A1A),
      selectedItemColor: const Color(0xFFFF3131),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: "Ticket"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}