import 'package:app_peliculas/domain/entities/movie.dart';
import 'package:app_peliculas/infrastructure/models/moviedb/movie_details.dart';
import 'package:app_peliculas/infrastructure/models/moviedb/movie_moviedb.dart';

// Mapeo general de Movies
class MovieMapper {
  // Mapeo del listado de Movies que muestra el home
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: (moviedb.backdropPath != '')
          ? 'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}'
          : 'https://sdlatlas.com/public/img/thumbnail.jpg',
      genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: (moviedb.overview != '')? moviedb.overview : 'Sin información de la pelicula.' ,
      popularity: moviedb.popularity,
      posterPath: (moviedb.posterPath != '')
          ? 'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'
          : 'https://www.filmfodder.com/reviews/images/poster-not-available.jpg',
      releaseDate: moviedb.releaseDate != null ? moviedb.releaseDate! : DateTime.now(),
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount);
  
  // Mapeo de la info de cada movie por id de acuerdo al listado de movies
  static Movie movieDetailsToEntity(MovieDetails moviedb) => Movie(
    adult: moviedb.adult,
      backdropPath: (moviedb.backdropPath != '')
          ? 'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}'
          : 'https://sdlatlas.com/public/img/thumbnail.jpg',
      genreIds: moviedb.genres.map((e) => e.name).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: (moviedb.overview != '')? moviedb.overview : 'Sin información de la pelicula.' ,
      popularity: moviedb.popularity,
      posterPath: (moviedb.posterPath != null)
          ? 'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'
          : 'https://www.filmfodder.com/reviews/images/poster-not-available.jpg',
      releaseDate: moviedb.releaseDate,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount
  );
}
