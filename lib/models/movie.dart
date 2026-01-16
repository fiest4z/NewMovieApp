class Movie {
  final String id;
  final String title;
  final String? description;
  final String? genre;
  final int? year;
  final double? rating;
  final bool isWatched;
  final DateTime dateAdded;
  final String? posterUrl;
  final String? backdropUrl;
  final int? tmdbId;
  final String? originalTitle;
  final List<String>? genres;

  Movie({
    required this.id,
    required this.title,
    this.description,
    this.genre,
    this.year,
    this.rating,
    this.isWatched = false,
    required this.dateAdded,
    this.posterUrl,
    this.backdropUrl,
    this.tmdbId,
    this.originalTitle,
    this.genres,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    String? genre,
    int? year,
    double? rating,
    bool? isWatched,
    DateTime? dateAdded,
    String? posterUrl,
    String? backdropUrl,
    int? tmdbId,
    String? originalTitle,
    List<String>? genres,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      rating: rating ?? this.rating,
      isWatched: isWatched ?? this.isWatched,
      dateAdded: dateAdded ?? this.dateAdded,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      tmdbId: tmdbId ?? this.tmdbId,
      originalTitle: originalTitle ?? this.originalTitle,
      genres: genres ?? this.genres,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'genre': genre,
      'year': year,
      'rating': rating,
      'isWatched': isWatched,
      'dateAdded': dateAdded.toIso8601String(),
      'posterUrl': posterUrl,
      'backdropUrl': backdropUrl,
      'tmdbId': tmdbId,
      'originalTitle': originalTitle,
      'genres': genres,
    };
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      genre: json['genre'] as String?,
      year: json['year'] as int?,
      rating: json['rating'] as double?,
      isWatched: json['isWatched'] as bool? ?? false,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      posterUrl: json['posterUrl'] as String?,
      backdropUrl: json['backdropUrl'] as String?,
      tmdbId: json['tmdbId'] as int?,
      originalTitle: json['originalTitle'] as String?,
      genres: json['genres'] != null
          ? List<String>.from(json['genres'] as List)
          : null,
    );
  }
}
