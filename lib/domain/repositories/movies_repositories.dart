import 'package:app_peliculas/domain/entities/movie.dart';


//La clase MovieRepository nos permite cambiar el Datasource
abstract class MoviesRepository {
  //getNowPlaying
  Future<List<Movie>> getNowPlaying({int page = 1});

  //getPopular
  Future<List<Movie>> getPopular({int page = 1});
  
  //getUpComing
  Future<List<Movie>> getUpComing({int page = 1});

  //getTopRated
  Future<List<Movie>> getTopRated({int page = 1});

  //getMovieById
  Future<Movie> getMovieById(String id);

  //searchMovies
  Future<List<Movie>> searchMovies(String query);
  
}
