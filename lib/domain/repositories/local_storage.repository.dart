import '../entities/movie.dart';

abstract class LocalStorageRepository {
  
  //Guardar la movie como favorita
  Future<void> toggleFavorite(Movie movie);

  //Validacion booleana por si la movie es favorita
  Future<bool> isMovieFavorite(int movieId);

  //Cargar la lista de Movies favoritas
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0});
}