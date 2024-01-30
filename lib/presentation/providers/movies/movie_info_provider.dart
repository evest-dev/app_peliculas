import 'package:app_peliculas/domain/entities/movie.dart';
import 'package:app_peliculas/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Crearemos un mapa que apunte a una instancia de Movie() de acuerdo al id en donde podremos manejar varias
//peliculas en base a las peticiones que hagamos y verificaremos si una pelicula esta cargada, si esta cargada
//no retorna nada, pero si no lo esta retorna la info de la movie

/*
  {
    '805642' : Movie(),
    '405254' : Movie(),
    '605168' : Movie().
    '535921' : Movie()
  }
*/

//Creacion del Provider de getMovie
final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider).getMovieById;

  return MovieMapNotifier(getMovie: movieRepository);
});

//MaperNotifier de getMovie que obtendra la info de las peliculas seleccionadas por su id

//definicion del callback
typedef GetMovieCallBack = Future<Movie> Function(String movieId);

//MaperNotifier que verificara, mapeara y traera la info de peliculas y retornara todo en una Movie()
class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  
  // definimos la funcion del callback
  final GetMovieCallBack getMovie;

  MovieMapNotifier({required this.getMovie}) : super({});

  //Cargado de peliculas de acuerdo a su id
  Future<void> loadMovie(String movieId) async {
    //verificamos si la movie existe
    if (state[movieId] != null) return;
    print('Realizando peticion http');
    // definimos movie que sera la funcion regresara un callback con el argumento del id de la Movie()
    final movie = await getMovie(movieId);

    //creamos el estado que retornara un nuevo estado, y la movieId que sera el id de la movie
    state = {...state, movieId: movie};
  }
}
