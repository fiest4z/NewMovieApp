import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/tmdb_movie.dart';

class MovieSearchResultCard extends StatelessWidget {
  final TmdbMovie movie;
  final VoidCallback onTap;

  const MovieSearchResultCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Постер фильма
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: movie.posterUrl != null
                    ? CachedNetworkImage(
                        imageUrl: movie.posterUrl!,
                        width: 60,
                        height: 90,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 60,
                          height: 90,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 60,
                          height: 90,
                          color: Colors.grey[300],
                          child: const Icon(Icons.movie_outlined),
                        ),
                      )
                    : Container(
                        width: 60,
                        height: 90,
                        color: Colors.grey[300],
                        child: const Icon(Icons.movie_outlined),
                      ),
              ),
              const SizedBox(width: 12),
              // Информация о фильме
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (movie.originalTitle != null && movie.originalTitle != movie.title) ...[
                      const SizedBox(height: 2),
                      Text(
                        movie.originalTitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                              fontStyle: FontStyle.italic,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (movie.year != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        movie.year.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                    if (movie.genresString != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        movie.genresString!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (movie.voteAverage != null && movie.voteAverage! > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${movie.voteAverage!.toStringAsFixed(1)}/10',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ],
                    if (movie.overview != null && movie.overview!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        movie.overview!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
