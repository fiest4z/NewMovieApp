import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tmdb_movie.dart';

class TmdbService {
  // ВАЖНО: Получите свой бесплатный API ключ на https://www.themoviedb.org/settings/api
  // Замените строку ниже на свой API ключ
  static const String _apiKey = 'YOUR_TMDB_API_KEY_HERE'; // Замените на свой ключ!
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p';

  // Поиск фильмов
  Future<List<TmdbMovie>> searchMovies(String query, {String language = 'ru-RU'}) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/search/movie?api_key=$_apiKey&language=$language&query=${Uri.encodeComponent(query)}',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>;

        return results
            .map((json) => TmdbMovie.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching movies: $e');
    }
  }

  // Получить детали фильма
  Future<TmdbMovie> getMovieDetails(int movieId, {String language = 'ru-RU'}) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/movie/$movieId?api_key=$_apiKey&language=$language',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return TmdbMovie.fromJson(data);
      } else {
        throw Exception('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading movie details: $e');
    }
  }

  // Популярные фильмы
  Future<List<TmdbMovie>> getPopularMovies({String language = 'ru-RU', int page = 1}) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/movie/popular?api_key=$_apiKey&language=$language&page=$page',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>;

        return results
            .map((json) => TmdbMovie.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load popular movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading popular movies: $e');
    }
  }

  // Топ фильмы
  Future<List<TmdbMovie>> getTopRatedMovies({String language = 'ru-RU', int page = 1}) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/movie/top_rated?api_key=$_apiKey&language=$language&page=$page',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>;

        return results
            .map((json) => TmdbMovie.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load top rated movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading top rated movies: $e');
    }
  }
}
