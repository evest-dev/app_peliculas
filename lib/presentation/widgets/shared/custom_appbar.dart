import 'dart:collection';

import 'package:app_peliculas/domain/entities/movie.dart';
import 'package:app_peliculas/presentation/delegates/search_movie_delegate.dart';
import 'package:app_peliculas/presentation/providers/movies/movies_repository_provider.dart';
import 'package:app_peliculas/presentation/providers/search/search_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.of(context).viewPadding.top;
    final hasMax = topPadding == 59.0 || topPadding == 47
        ? 70
        : topPadding > 49.45
            ? 0
            : 0;
    // print('Appbar: $hasMax');
    return SafeArea(
      bottom: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: hasMax.toDouble()),
          Icon(
            Icons.view_agenda_outlined,
            color: colors.secondary,
          ),          
          SizedBox(
            width: 70,
            child: IconButton(
              onPressed: () {
                //movieRepository que buscara el listado de peliculas
                final searchedMovies = ref.read(searchedMoviesProvider);

                //searchQuery guarda el estado de la busqueda
                final searchQuery = ref.read(searchQueryProvider);

                showSearch<Movie?>(
                        context: context,
                        query: searchQuery,
                        delegate: SearchMovieDelegate(
                            searchMovies:
                                //leemos el searchedMoviesProvider y notificamos el estado del query con searchedMovies
                                //para que se mantenga cada que salimos de la busqueda
                                ref
                                    .read(searchedMoviesProvider.notifier)
                                    .searchedMoviesByQuery,
                            initialMovies: searchedMovies
                            //retornamos la lista de pelicilas
                            ))
                    .then((movie) {
                  if (movie == null) return;
                  context.go('/home/0/movie/${movie.id}');
                });
              },
              icon: Icon(
                Icons.search,
                color: colors.secondary,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
