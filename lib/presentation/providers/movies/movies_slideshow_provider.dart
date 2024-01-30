import 'package:riverpod/riverpod.dart';
import 'package:app_peliculas/domain/entities/movie.dart';
import 'movies_providers.dart';

//Provider para crear el listado de 6 peliculas que son las mas vistas dinamicamente
final moviesSlideShowProvider = Provider<List<Movie>>((ref) {
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
  if (nowPlayingMovies.isEmpty) return [];

  return nowPlayingMovies.sublist(0,7);
});
