import 'package:app_peliculas/domain/entities/movie.dart';
import 'package:app_peliculas/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider para guardar el estado de la busqueda
final searchQueryProvider = StateProvider<String>((ref) => '');

//definicion de la funcion para buscar las movies
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

final searchedMoviesProvider =
    StateNotifierProvider<searchedMoviesNotifier, List<Movie>>((ref) {
    final movieRepository = ref.read(movieRepositoryProvider);
  return searchedMoviesNotifier(searchedMovies: movieRepository.searchMovies, ref: ref);
});

//Provider para guardar el listado de movies previamente cargadas de acuerdo al estado de la busqueda
class searchedMoviesNotifier extends StateNotifier<List<Movie>> {
  SearchMoviesCallback searchedMovies;
  final Ref ref;
  searchedMoviesNotifier({required this.searchedMovies, required this.ref})
      : super([]);

  //Funcion para cargar la lista de movies buscada anteriormente por su query
  Future<List<Movie>> searchedMoviesByQuery(String query) async {
    final List<Movie> movies = await searchedMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = movies;
    return movies;
  }
}
