import 'package:app_peliculas/domain/datasourses/movies_datasources.dart';
import 'package:app_peliculas/domain/entities/movie.dart';
import 'package:app_peliculas/domain/repositories/movies_repositories.dart';

// Implementacion del MovieRepositoryImpl para que se puedan cambiar los origenes de datos y
// con los providers de riverpod llamar facilmente todo el mecanismo de funcionalidad

class MovieRepositoryImpl extends MoviesRepository {
  final MoviesDataSource dataSources;

  MovieRepositoryImpl(this.dataSources);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return dataSources.getNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return dataSources.getPoPular(page: page);
  }

  @override
  Future<List<Movie>> getUpComing({int page = 1}) {
    return dataSources.getUpComing(page: page);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return dataSources.getTopRated(page: page);
  }

  //implementacion del getMovieById en donde obtendremos toda la info de la movie seleccionada
  @override
  Future<Movie> getMovieById(String id) {
    return dataSources.getMovieById(id);
  }

  //implementacion del searchMovies en donde buscaremos las peliculas basado en el texto escrito
  @override
  Future<List<Movie>> searchMovies(String query) {
    return dataSources.searchMovies(query);
  }
}
