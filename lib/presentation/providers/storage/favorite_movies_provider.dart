import 'package:app_peliculas/domain/repositories/local_storage.repository.dart';
import 'package:app_peliculas/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_peliculas/domain/entities/movie.dart';

final favoriteMoviesProvider =
    StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});

//Modelo -> Retorna el id de la movie y toda la info de la movie seleccionada como favorito
/* 
{
  12345: Movie,
  54321: Movie,
  23451: Movie
}
*/

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;
  StorageMoviesNotifier({required this.localStorageRepository}) : super({});

  Future<List<Movie>> loadNextPage() async {
    final movies =
        await localStorageRepository.loadMovies(offset: page * 10, limit: 20);
    page++;

    final tempMoviesMap = <int, Movie>{};
    for (final movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }
    state = {...state, ...tempMoviesMap};

    return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {
    await localStorageRepository.toggleFavorite(movie);
    final bool isMovieInFavorite = state[movie.id] != null;

    if (isMovieInFavorite) {
      state.remove(movie.id);
      state = {...state };
    }
    else {
      state = {...state, movie.id: movie };
    }
  }
}
