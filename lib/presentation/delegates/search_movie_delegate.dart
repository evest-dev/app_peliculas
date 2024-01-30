import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:app_peliculas/config/helpers/humans_formats.dart';
import 'package:flutter/material.dart';
import 'package:app_peliculas/domain/entities/movie.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  //searchMovies retorna una funcion que por su query de busqueda devolvera un future con la lista de peliculas
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  //debounceMovie escuchara la peticion y devolvera una lista de movies que sera emitido por la funcion _onQueryChanged y
  //de esa forma solo se hara una peticion y no multiples por cada que se escriba una letra en la busqueda
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();

  //
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;
  SearchMovieDelegate(
      {required this.searchMovies, required this.initialMovies});

  //Funcion que cierra el Stream una vez se realiza la busqueda
  void clearStreams() {
    debouncedMovies.close();
  }

  //Funcion que retorna una lista de movies en base al query
  void _onQueryChanged(String query) {
    isLoadingStream.add(true);

    print('Query String cabio');
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(microseconds: 500), () async {
      // if (query.isEmpty) {
      //   debouncedMovies.add([]);
      //   return;
      // }
      final movies = await searchMovies(query);
      initialMovies = movies;
      debouncedMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  @override
  //cambiar el nombre que aparece en la busqueda
  get searchFieldLabel => 'Buscar';

  //buildActions => Dispara multiples acciones, en este caso nos sirve para validar si hay algo escrito y limpiar la busqueda
  @override
  List<Widget>? buildActions(BuildContext context) {
    print('$query');
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? true) {
            return SpinPerfect(
                duration: const Duration(seconds: 20),
                spins: 10,
                child: IconButton(
                    onPressed: () => query = '',
                    icon: const Icon(Icons.refresh)));
          }

          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
                onPressed: () => query = '', icon: const Icon(Icons.clear)),
          );
        },
      )
    ];
  }

  //buildLeading => dispara varias acciones, en este caso cumple la funcion de retroceder y llevar al home
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  //buildResults => dispara varias acciones, en este caso se utilizara para mostrar los resultados
  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  //buildSuggestions => dispara varias acciones, en este caso se utilizara para mostrar las sugerencias mientras se vaya escribiendo
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) => _MovieItem(
                movie: movies[index],
                onMovieSelected: (context, movie) {
                  clearStreams();
                  close(context, movie);
                }));
      },
      stream: debouncedMovies.stream,
      initialData: initialMovies,
      // future: searchMovies(query),
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    // Funcion para generar estrellas
    List<Icon> generateStars(double valor) {
      int cantidadEstrellas = (valor / 2).floor().clamp(0, 5);
      List<Icon> iconosEstrellas = List.generate(5, (index) {
        return Icon(
          index < cantidadEstrellas ? Icons.star : Icons.star_border_outlined,
          color: Colors.yellow.shade800,
          size: 20,
        );
      });
      return iconosEstrellas;
    }

    //Asignar estrellas de acuerdo al puntaje de las movies
    List<Icon> estrellas = generateStars(movie.voteAverage);

    return GestureDetector(
      onTap: () => onMovieSelected(context, movie),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            //Image
            FadeIn(
              duration: const Duration(microseconds: 100),
              child: SizedBox(
                width: size.width * 0.22,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(movie.posterPath),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title,
                      style: textStyle.titleLarge
                          ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2),
                  const SizedBox(height: 4),
                  movie.overview.length > 100
                      ? Text(movie.overview,
                          overflow: TextOverflow.ellipsis, maxLines: 3)
                      : Text(movie.overview),
                  const SizedBox(height: 15),
                  Row(children: [
                    Text('${DateTime(movie.releaseDate.year).year} •'),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${HumanFormats.number(movie.popularity)} Me Gusta',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(children: estrellas)
                  ])
                ],
              ),
            ),

            //Description
          ],
        ),
      ),
    );
  }
}
