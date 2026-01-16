import 'package:flutter/material.dart';
import '../models/omdb_movie.dart';
import '../models/movie.dart';
import '../services/omdb_service.dart';
import '../widgets/movie_search_result_card.dart';

class MovieSearchScreen extends StatefulWidget {
  final Function(Movie) onMovieSelected;

  const MovieSearchScreen({
    super.key,
    required this.onMovieSelected,
  });

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final OmdbService _omdbService = OmdbService();
  final TextEditingController _searchController = TextEditingController();
  List<OmdbMovie> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _currentQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchMovies(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _currentQuery = query;
    });

    try {
      final results = await _omdbService.searchMovies(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка поиска: $e';
        _isLoading = false;
        _searchResults = [];
      });
    }
  }

  void _selectMovie(OmdbMovie omdbMovie) {
    final movie = Movie(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: omdbMovie.title,
      description: omdbMovie.plot,
      year: omdbMovie.yearInt,
      rating: omdbMovie.ratingDouble != null
          ? (omdbMovie.ratingDouble! / 2) // Конвертируем из 10-балльной в 5-балльную
          : null,
      genre: omdbMovie.genre,
      posterUrl: omdbMovie.posterUrl,
      tmdbId: int.tryParse(omdbMovie.imdbID.replaceAll('tt', '')),
      genres: omdbMovie.genre?.split(', '),
      dateAdded: DateTime.now(),
    );

    widget.onMovieSelected(movie);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск фильмов'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Введите название фильма...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchMovies('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (value) {
                // Debounce поиск
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (_searchController.text == value) {
                    _searchMovies(value);
                  }
                });
              },
              onSubmitted: _searchMovies,
              autofocus: true,
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _searchResults.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _searchMovies(_currentQuery),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty && _currentQuery.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Начните поиск фильмов',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Введите название фильма в поле поиска',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Фильмы не найдены',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить запрос',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final movie = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: MovieSearchResultCard(
            movie: movie,
            onTap: () => _selectMovie(movie),
          ),
        );
      },
    );
  }
}
