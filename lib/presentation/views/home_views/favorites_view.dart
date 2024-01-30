import 'package:app_peliculas/presentation/providers/providers.dart';
import 'package:app_peliculas/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';

class FavoritesView extends ConsumerStatefulWidget {
  static const name = 'favorites-view';
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;

    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();
    if (favoriteMovies.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No hay peliculas favoritas!'),
            const SizedBox(height: 10),
            FilledButton.tonal(
                onPressed: () {
                  context.go('/home/0');
                },
                child: const Text('Añadir peliculas'))
          ],
        ),
      );
    }

    return Scaffold(
        body: MovieMasonry(loadNextPage: loadNextPage, movies: favoriteMovies));
  }
}
