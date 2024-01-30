import 'package:app_peliculas/infrastructure/datasources/actors_moviedb_datasource.dart';
import 'package:app_peliculas/infrastructure/repositories/actors_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Este repositorio es inmutable
final actorsRepositoryProvider = Provider((ref) {
  //Implementamos el Datasource unicamente para traer la info de TheMovieDb, 
  //si queremos cambiar de fuente de datos como IBMDB, entonces cambiamos lo 
  //que hay dentro de ActorRepositoryImpl()
  return ActorRepositoryImpl(ActorMovieDbDataSource());
});
