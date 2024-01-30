import 'package:app_peliculas/domain/entities/actors.dart';
import 'package:app_peliculas/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Crearemos un mapa que apunte a una instancia de Actors() de acuerdo al id en donde podremos manejar varias
//peliculas en base a las peticiones que hagamos y verificaremos si los actores de la pelicula seleccionada esta cargada, 
//si esta cargada no retorna nada, pero si no lo esta retorna la info de los actores de la movie

/*
  {
    '805642' : <Actor>[],
    '405254' : <Actor>[],
    '605168' : <Actor>[],
    '535921' : <Actor>[],
  }
*/

//Creacion del Provider de getActors
final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {
  
  final actorsRepository = ref.watch(actorsRepositoryProvider);
  return ActorsByMovieNotifier(getActors: actorsRepository.getActorsByMovie);

});

//MaperNotifier de getActors que obtendra la info los actores de las peliculas seleccionadas por su id

//definicion del callback
typedef GetActorsCallBack = Future<List<Actor>> Function(String movieId);

//MaperNotifier que verificara, mapeara y traera la info de los actores de peliculas y retornara todo en un Actor()
class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  
  // definimos la funcion del callback
  final GetActorsCallBack getActors;

  ActorsByMovieNotifier({required this.getActors}) : super({});

  //Cargado de los actores de las peliculas de acuerdo a su id
  Future<void> loadActors(String movieId) async {
    //verificamos actores de la movie seleccionada por su id 
    if (state[movieId] != null) return;
    print('Realizando peticion http');

    // definimos actors que sera la funcion regresara un callback con el argumento del id del Actor()
    final actors = await getActors(movieId);

    //creamos el estado que retornara un nuevo estado, y la movieId que sera el id del actors
    state = {...state, movieId: actors};
  }
}
