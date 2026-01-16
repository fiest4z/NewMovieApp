import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import 'auth_service.dart';

class StorageService {
  final AuthService _authService = AuthService();

  String _getMoviesKey(String? userId) {
    if (userId != null) {
      return 'saved_movies_$userId';
    }
    return 'saved_movies_guest';
  }

  Future<String?> _getCurrentUserId() async {
    final user = await _authService.getCurrentUser();
    return user?.id;
  }

  Future<List<Movie>> getMovies() async {
    final userId = await _getCurrentUserId();
    final prefs = await SharedPreferences.getInstance();
    final moviesKey = _getMoviesKey(userId);
    final moviesJson = prefs.getString(moviesKey);
    
    if (moviesJson == null) {
      return [];
    }

    final List<dynamic> decoded = json.decode(moviesJson);
    return decoded.map((json) => Movie.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> saveMovies(List<Movie> movies) async {
    final userId = await _getCurrentUserId();
    final prefs = await SharedPreferences.getInstance();
    final moviesKey = _getMoviesKey(userId);
    final moviesJson = json.encode(
      movies.map((movie) => movie.toJson()).toList(),
    );
    await prefs.setString(moviesKey, moviesJson);
  }

  Future<void> addMovie(Movie movie) async {
    final movies = await getMovies();
    movies.add(movie);
    await saveMovies(movies);
  }

  Future<void> updateMovie(Movie updatedMovie) async {
    final movies = await getMovies();
    final index = movies.indexWhere((m) => m.id == updatedMovie.id);
    if (index != -1) {
      movies[index] = updatedMovie;
      await saveMovies(movies);
    }
  }

  Future<void> deleteMovie(String movieId) async {
    final movies = await getMovies();
    movies.removeWhere((m) => m.id == movieId);
    await saveMovies(movies);
  }
}
