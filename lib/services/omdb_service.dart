import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/omdb_movie.dart';

class OmdbService {
  // ВАЖНО: Получите свой бесплатный API ключ на http://www.omdbapi.com/apikey.aspx
  // Замените строку ниже на свой API ключ
  static const String _apiKey = '60bd749f'; // Замените на свой ключ!
  static const String _baseUrl = 'http://www.omdbapi.com';

  // Поиск фильмов
  Future<List<OmdbMovie>> searchMovies(String query) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/?apikey=$_apiKey&s=${Uri.encodeComponent(query)}&type=movie',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        
        if (data['Response'] == 'False') {
          // Нет результатов или ошибка
          if (data['Error'] != null) {
            throw Exception(data['Error'] as String);
          }
          return [];
        }

        final results = data['Search'] as List<dynamic>?;
        if (results == null || results.isEmpty) {
          return [];
        }

        // Получаем детали для каждого фильма
        final List<OmdbMovie> movies = [];
        for (var item in results) {
          final imdbId = (item as Map<String, dynamic>)['imdbID'] as String?;
          if (imdbId != null) {
            try {
              final details = await getMovieDetails(imdbId);
              movies.add(details);
            } catch (e) {
              // Если не удалось получить детали, используем базовую информацию
              movies.add(OmdbMovie.fromJson(item));
            }
          }
        }

        return movies;
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching movies: $e');
    }
  }

  // Получить детали фильма по IMDB ID
  Future<OmdbMovie> getMovieDetails(String imdbId) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/?apikey=$_apiKey&i=$imdbId&plot=full',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        
        if (data['Response'] == 'False') {
          throw Exception(data['Error'] as String? ?? 'Movie not found');
        }

        return OmdbMovie.fromJson(data);
      } else {
        throw Exception('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading movie details: $e');
    }
  }

  // Поиск фильма по названию (точное совпадение)
  Future<OmdbMovie?> searchMovieByTitle(String title) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/?apikey=$_apiKey&t=${Uri.encodeComponent(title)}&type=movie&plot=full',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        
        if (data['Response'] == 'False') {
          return null;
        }

        return OmdbMovie.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
