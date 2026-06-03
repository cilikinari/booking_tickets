import 'package:flutter/material.dart';
import '../../data/movie_data.dart'; // Provider yang mengambil data dari Data Layer

class MovieProvider with ChangeNotifier {
  // Provider menampung data dummy dari MovieData
  dynamic get topMovies => MovieData.topMovies;
  dynamic get nowPlaying => MovieData.nowPlaying;

  // Besok pas mau pakai API, kamu tinggal bikin fungsi fetching-nya di sini!
}