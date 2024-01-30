import 'package:app_peliculas/infrastructure/datasources/moviedb_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_peliculas/infrastructure/repositories/movie_repository_impl.dart';

//Este repositorio es inmutable
final movieRepositoryProvider = Provider((ref) {
  //Implementamos el Datasource unicamente para traer la info de TheMovieDb, 
  //si queremos cambiar de fuente de datos como IBMDB, entonces cambiamos lo 
  //que hay dentro de MovieRepositoryImpl()
  return MovieRepositoryImpl(MovieDbDataSource());
});
