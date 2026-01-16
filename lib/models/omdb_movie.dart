class OmdbMovie {
  final String imdbID;
  final String title;
  final String? plot;
  final String? year;
  final String? imdbRating;
  final String? poster;
  final String? genre;
  final String? director;
  final String? actors;
  final String? runtime;
  final String? released;

  OmdbMovie({
    required this.imdbID,
    required this.title,
    this.plot,
    this.year,
    this.imdbRating,
    this.poster,
    this.genre,
    this.director,
    this.actors,
    this.runtime,
    this.released,
  });

  factory OmdbMovie.fromJson(Map<String, dynamic> json) {
    return OmdbMovie(
      imdbID: json['imdbID'] as String? ?? '',
      title: json['Title'] as String? ?? json['title'] as String? ?? '',
      plot: json['Plot'] as String? ?? json['plot'] as String?,
      year: json['Year'] as String? ?? json['year'] as String?,
      imdbRating: json['imdbRating'] as String? ?? json['rating'] as String?,
      poster: json['Poster'] as String? ?? json['poster'] as String?,
      genre: json['Genre'] as String? ?? json['genre'] as String?,
      director: json['Director'] as String? ?? json['director'] as String?,
      actors: json['Actors'] as String? ?? json['actors'] as String?,
      runtime: json['Runtime'] as String? ?? json['runtime'] as String?,
      released: json['Released'] as String? ?? json['released'] as String?,
    );
  }

  String? get posterUrl {
    if (poster == null || poster == 'N/A') return null;
    return poster;
  }

  int? get yearInt {
    if (year == null || year == 'N/A') return null;
    try {
      return int.parse(year!);
    } catch (e) {
      return null;
    }
  }

  double? get ratingDouble {
    if (imdbRating == null || imdbRating == 'N/A') return null;
    try {
      return double.parse(imdbRating!);
    } catch (e) {
      return null;
    }
  }
}
