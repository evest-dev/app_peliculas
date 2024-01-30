import 'package:app_peliculas/domain/entities/movie.dart';

//Definir los metodos para traer la data
abstract class MoviesDataSource {
  //getNowPlaying
  Future<List<Movie>> getNowPlaying({int page = 1});

  //getPopular
  Future<List<Movie>> getPoPular({int page = 1});
  
  //getUpComing
  Future<List<Movie>> getUpComing({int page = 1});

  //getTopRated
  Future<List<Movie>> getTopRated({int page = 1});

  //getMovieById obtiene los datos de la pelicula seleccionada
  Future<Movie> getMovieById(String id);

  //searchMovies que obtendran las movies de acuerdo al query de busqueda
  Future<List<Movie>> searchMovies(String query);
}
