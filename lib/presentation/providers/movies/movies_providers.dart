import 'package:app_peliculas/domain/entities/movie.dart';
import 'package:app_peliculas/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//StateNotifierProvider => Es un proveedor de informacion que notifica cuando cambia el estado
//Statenotifier => Es una clase que sirve para manejar su estado

//nowPlayingMoviesProvider es el controlador del estado de la clase MoviesNotifier
final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  //retornamos la instancia de MoviesNotifier(), la cual nos pedira el argumento del fetchMoreMovies,
  //este lo extraemos con provider ref.watch ( movieRepositoryProvider)

  //creamos la variable fetchMoreMovies en donde extraeremos con provider el argumento que necesitamos,
  //en este caso del getnowPlaying
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

  //retornamos la instancia MoviesNotifier con su argumento extraido
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});


//popularMoviesProvider es el controlador del estado de la clase MoviesNotifier
final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  //retornamos la instancia de MoviesNotifier(), la cual nos pedira el argumento del fetchMoreMovies,
  //este lo extraemos con provider ref.watch ( movieRepositoryProvider)

  //creamos la variable fetchMoreMovies en donde extraeremos con provider el argumento que necesitamos,
  //en este caso del getPopular
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;

  //retornamos la instancia MoviesNotifier con su argumento extraido
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});


//UpcomingMoviesProvider es el controlador del estado de la clase MoviesNotifier
final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  //retornamos la instancia de MoviesNotifier(), la cual nos pedira el argumento del fetchMoreMovies,
  //este lo extraemos con provider ref.watch ( movieRepositoryProvider)

  //creamos la variable fetchMoreMovies en donde extraeremos con provider el argumento que necesitamos,
  //en este caso del getUpComing
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpComing;

  //retornamos la instancia MoviesNotifier con su argumento extraido
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});


//getUpcomingrMoviesProvider es el controlador del estado de la clase MoviesNotifier
final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  //retornamos la instancia de MoviesNotifier(), la cual nos pedira el argumento del fetchMoreMovies,
  //este lo extraemos con provider ref.watch ( movieRepositoryProvider)

  //creamos la variable fetchMoreMovies en donde extraeremos con provider el argumento que necesitamos,
  //en este caso del getTopRated
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;

  //retornamos la instancia MoviesNotifier con su argumento extraido
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});


//Definimos el MovieCallBack que es una funcion que nos retornara un listado de Movie (peliculas),
//especialmente el int del page (1,2,3)
typedef MovieCallBack = Future<List<Movie>> Function({int page});

// Creamos la instancia de MoviesNotifier que proporcinara un listado de Movie (peliculas),
// este nos permitira controlarlo por medio del StateNotifierProvider.
// DATO: Con el movieNotifier podemos extraer varias cosas, en este caso nos ayudara a estructurar
// las funciones que necesitaremos para cargar la info necesaria, como por ejemplo del 'getNowPlaying'
class MoviesNotifier extends StateNotifier<List<Movie>> {
  //bool para controlar las peticiones http por carga
  bool isLoading = false;

  //currentPage
  int currentPage = 0;

  //definimos a MovieCallBack como fetchMoreMovies reutilizaremos para crear listas vacias de Movie (peliculas)
  MovieCallBack fetchMoreMovies;

  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  //Funcion CargarPagina del 'getNowPlaying' que nos permitira crear un nuevo state del loadNextPage
  // en donde pasaremos todo el arreglo del state anterior y las movies
  // state = [...state, movies]
  Future<void> loadNextPage() async {
    //controlar 1 vez por carga las peticiones http, mientras sea isLoading = true las peticiones se detienen
    if (isLoading) return;
    //cambiamos a true para que al finalizar la primera carga la peticion se detenga
    isLoading = true;

    // incrementamos consecutivamente para que el index sea de 1 en adelante
    currentPage++;
    //Envolvemos en un nuevo listado las movies de acuerdo a la
    //funcion fetchMoreMovies del MovieCallBack en donde le pasamos
    //el page CurrentPage para que su index empiece desde 1 ya que su valor por defecto es 0
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);

    //creamos el nuevo state para loadNextPage en donde pasaremos el state anterior y las movies
    state = [...state, ...movies];

    //agregar un duration de 300 para suavizar la nueva peticion http antes de cambiar el valor de isLoading
    await Future.delayed(const Duration(microseconds: 500));
    
    //una vez se complete la carga solicitada cambiamos isLoading a false para que muestre la siguiente peticion
    isLoading = false;
  }
}
