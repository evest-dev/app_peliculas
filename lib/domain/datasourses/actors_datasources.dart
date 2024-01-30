import 'package:app_peliculas/domain/entities/actors.dart';

//Definir los metodos para traer la data
abstract class ActorsDatasource {
  //Obtener actores por la movie seleccionada
  Future<List<Actor>> getActorsByMovie(String movieId);
}
