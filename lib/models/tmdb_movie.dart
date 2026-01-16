class TmdbMovie {
  final int id;
  final String title;
  final String? overview;
  final String? releaseDate;
  final double? voteAverage;
  final String? posterPath;
  final String? backdropPath;
  final String? originalTitle;
  final List<Map<String, dynamic>>? genres;

  TmdbMovie({
    required this.id,
    required this.title,
    this.overview,
    this.releaseDate,
    this.voteAverage,
    this.posterPath,
    this.backdropPath,
    this.originalTitle,
    this.genres,
  });

  factory TmdbMovie.fromJson(Map<String, dynamic> json) {
    return TmdbMovie(
      id: json['id'] as int,
      title: json['title'] as String? ?? json['original_title'] as String? ?? '',
      overview: json['overview'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: json['vote_average'] != null
          ? (json['vote_average'] as num).toDouble()
          : null,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      originalTitle: json['original_title'] as String?,
      genres: json['genres'] != null
          ? List<Map<String, dynamic>>.from(json['genres'] as List)
          : null,
    );
  }

  String? get posterUrl {
    if (posterPath == null) return null;
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String? get backdropUrl {
    if (backdropPath == null) return null;
    return 'https://image.tmdb.org/t/p/w1280$backdropPath';
  }

  int? get year {
    if (releaseDate == null || releaseDate!.isEmpty) return null;
    try {
      return DateTime.parse(releaseDate!).year;
    } catch (e) {
      return null;
    }
  }

  String? get genresString {
    if (genres == null || genres!.isEmpty) return null;
    return genres!.map((g) => g['name'] as String).join(', ');
  }
}
