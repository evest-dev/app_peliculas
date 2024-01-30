
import 'package:app_peliculas/domain/entities/actors.dart';


abstract class ActorsRepository {
  
  //Obtener actores por la movie seleccionada
  Future<List<Actor>> getActorsByMovie(String movieId);
}
