import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../services/storage_service.dart';
import '../widgets/movie_card.dart';
import '../widgets/add_movie_dialog.dart';
import 'movie_search_screen.dart';
import 'profile_screen.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final StorageService _storageService = StorageService();
  List<Movie> _movies = [];
  bool _isLoading = true;
  String _filter = 'all'; // 'all', 'watched', 'unwatched'

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() => _isLoading = true);
    final movies = await _storageService.getMovies();
    setState(() {
      _movies = movies;
      _isLoading = false;
    });
  }

  List<Movie> get _filteredMovies {
    switch (_filter) {
      case 'watched':
        return _movies.where((m) => m.isWatched).toList();
      case 'unwatched':
        return _movies.where((m) => !m.isWatched).toList();
      default:
        return _movies;
    }
  }

  Future<void> _addMovie(Movie movie) async {
    await _storageService.addMovie(movie);
    _loadMovies();
  }

  Future<void> _updateMovie(Movie movie) async {
    await _storageService.updateMovie(movie);
    _loadMovies();
  }

  Future<void> _deleteMovie(String movieId) async {
    await _storageService.deleteMovie(movieId);
    _loadMovies();
  }

  Future<void> _toggleWatchedStatus(Movie movie) async {
    await _updateMovie(movie.copyWith(isWatched: !movie.isWatched));
  }

  void _showAddMovieDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Поиск фильма'),
              subtitle: const Text('Найти фильм в базе OMDb/IMDB'),
              onTap: () {
                Navigator.pop(context);
                _showMovieSearch();
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Добавить вручную'),
              subtitle: const Text('Создать запись о фильме'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AddMovieDialog(
                    onSave: _addMovie,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMovieSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieSearchScreen(
          onMovieSelected: _addMovie,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredMovies = _filteredMovies;
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Watchlist',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_movies.length} ${_movies.length == 1 ? 'movie' : 'movies'} saved',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton.filled(
                            onPressed: _showMovieSearch,
                            icon: const Icon(Icons.search),
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                              foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                            tooltip: 'Поиск фильма',
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            onPressed: _showAddMovieDialog,
                            icon: const Icon(Icons.add),
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                            ),
                            tooltip: 'Добавить фильм',
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              );
                              // Обновляем данные при возврате из профиля
                              _loadMovies();
                            },
                            icon: const Icon(Icons.person),
                            tooltip: 'Профиль',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Filter chips
                  Row(
                    children: [
                      _buildFilterChip('all', 'All'),
                      const SizedBox(width: 8),
                      _buildFilterChip('unwatched', 'To Watch'),
                      const SizedBox(width: 8),
                      _buildFilterChip('watched', 'Watched'),
                    ],
                  ),
                ],
              ),
            ),
            // Movie list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredMovies.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredMovies.length,
                          itemBuilder: (context, index) {
                            final movie = filteredMovies[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: MovieCard(
                                movie: movie,
                                onTap: () => _showMovieDetails(movie),
                                onToggleWatched: () => _toggleWatchedStatus(movie),
                                onDelete: () => _deleteMovie(movie.id),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filter = value);
      },
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
    );
  }

  Widget _buildEmptyState() {
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
            _filter == 'all'
                ? 'No movies saved yet'
                : _filter == 'watched'
                    ? 'No watched movies'
                    : 'No movies to watch',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _filter == 'all'
                ? 'Tap the + button to add your first movie'
                : 'Try a different filter',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showMovieDetails(Movie movie) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MovieDetailsSheet(
        movie: movie,
        onToggleWatched: () {
          _toggleWatchedStatus(movie);
          Navigator.pop(context);
        },
        onDelete: () {
          _deleteMovie(movie.id);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class MovieDetailsSheet extends StatelessWidget {
  final Movie movie;
  final VoidCallback onToggleWatched;
  final VoidCallback onDelete;

  const MovieDetailsSheet({
    super.key,
    required this.movie,
    required this.onToggleWatched,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Movie poster if available
              if (movie.posterUrl != null) ...[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: movie.posterUrl!,
                      width: 150,
                      height: 225,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 150,
                        height: 225,
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 150,
                        height: 225,
                        color: Colors.grey[300],
                        child: const Icon(Icons.movie, size: 64),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: Text(
                      movie.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    movie.isWatched ? Icons.check_circle : Icons.check_circle_outline,
                    color: movie.isWatched
                        ? Colors.green
                        : Colors.grey,
                    size: 28,
                  ),
                ],
              ),
              if (movie.year != null || movie.genre != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (movie.year != null) ...[
                      Chip(
                        label: Text('${movie.year}'),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (movie.genre != null)
                      Chip(
                        label: Text(movie.genre!),
                        padding: EdgeInsets.zero,
                      ),
                  ],
                ),
              ],
              if (movie.rating != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      movie.rating!.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
              if (movie.description != null) ...[
                const SizedBox(height: 24),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        onToggleWatched();
                      },
                      icon: Icon(
                        movie.isWatched ? Icons.undo : Icons.check,
                      ),
                      label: Text(movie.isWatched ? 'Mark Unwatched' : 'Mark Watched'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Movie'),
                            content: Text('Are you sure you want to delete "${movie.title}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  onDelete();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
