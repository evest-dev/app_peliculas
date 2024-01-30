import 'package:app_peliculas/domain/datasourses/actors_datasources.dart';
import 'package:app_peliculas/domain/entities/actors.dart';
import 'package:app_peliculas/domain/repositories/actors_repository.dart';
import 'package:app_peliculas/infrastructure/datasources/actors_moviedb_datasource.dart';

// Implementacion del ActorRepositoryImpl para que se puedan cambiar los origenes de datos y
// con los providers de riverpod llamar facilmente todo el mecanismo de funcionalidad

class ActorRepositoryImpl extends ActorsRepository {
  final ActorsDatasource datasource;

  ActorRepositoryImpl(this.datasource);
  
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasource.getActorsByMovie(movieId);
  }
}
