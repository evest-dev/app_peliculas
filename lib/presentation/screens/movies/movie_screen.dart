import 'package:app_peliculas/presentation/providers/storage/local_storage_provider.dart';
import 'package:app_peliculas/presentation/widgets/shared/gen_years_stars.dart';
import 'package:animate_do/animate_do.dart';
import 'package:app_peliculas/domain/entities/movie.dart';
import 'package:app_peliculas/presentation/providers/actors/actors_by_movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_peliculas/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    //peticion http para extraer la info de peliculas por su id
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);

    //peticion http para extraer la info los actores de las peliculas por su id
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    //extraemos en el objeto movie el id de la movie seleccionada
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    //validamos si el id de la movie existe
    if (movie == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    return Scaffold(
        body: CustomScrollView(
      //evitar el rebote que da en ios por default
      physics: const ClampingScrollPhysics(),

      slivers: [
        //Imagen
        _CustomSliverApp(movie: movie),

        //Info
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => _CustomMovieInfo(movie: movie),
                childCount: 1))
      ],
    ));
  }
}

final isFavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return localStorageRepository.isMovieFavorite(movieId); //si esta en favorito
});

class _CustomSliverApp extends ConsumerWidget {
  final Movie movie;
  const _CustomSliverApp({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //obtenemos el size para posteriormente colocar la imagen en el size definido
    final size = MediaQuery.of(context).size;
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return SliverAppBar(
      backgroundColor: Colors.black54,
      actions: [
        IconButton(
            //TODO: Realizar la funcionalidad del like de las movies
            onPressed: () async {
              // ref.read(localStorageRepositoryProvider).toggleFavorite(movie);
              await ref.read(favoriteMoviesProvider.notifier).toggleFavorite(movie);
              ref.invalidate(isFavoriteProvider(movie.id));
            },
            icon: isFavoriteFuture.when(
                loading: () => const CircularProgressIndicator(strokeWidth: 2),
                data: (isFavorite) => isFavorite
                    ? const Icon(Icons.favorite_rounded, color: Colors.red)
                    : const Icon(Icons.favorite_border),
                error: (_, __) => throw UnimplementedError()))
      ],
      //expandedHeight: size.height * 0.9,
      expandedHeight: size.height * 0.6,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 0),
        title: _CustomGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.7, 1.0],
            colors: [Colors.black12, scaffoldBackgroundColor]),
        background: Stack(children: [
          // Imagen
          SizedBox.expand(
              // boxFit.fill para pantallas grandes
              child: FadeIn(
                  child: Image.network(movie.posterPath, fit: BoxFit.fill))),

          // Gradiente Imagen
          const SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                      Colors.black12
                    ]),
              ),
            ),
          ),

          //* Favorite Gradient Background
          const _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.1],
              colors: [Colors.black54, Colors.transparent]),
        ]),
      ),
    );
  }
}

class _CustomMovieInfo extends StatelessWidget {
  final Movie movie;
  const _CustomMovieInfo({required this.movie});

  @override
  Widget build(BuildContext context) {
    // Personalizar estilo de letra
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titulo de Pelicula Seleccionada
          Text(movie.title,
              style: textStyle.titleLarge?.copyWith(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                  fontSize: 35),
              textAlign: TextAlign.start),
          const SizedBox(height: 20),

          //Año, genero, estrellas
          YearGenStarts(movie: movie),
          const SizedBox(height: 20),

          // Actores de las peliculas
          Text('Reseña',
              style: textStyle.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w500, fontSize: 18)),
          const SizedBox(height: 5),

          // Descripcion de Pelicula Seleccionada
          Text(
            movie.overview,
            style: textStyle.labelLarge?.copyWith(fontSize: 15),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),

          // Actores de las peliculas
          Text('Reparto',
              style: textStyle.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.white70),
              textAlign: TextAlign.start),
          const SizedBox(height: 10),

          _ActorsByMovie(movieId: movie.id.toString()),

          const SizedBox(height: 20)
        ],
      ),
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    //lectura de los actores de la pelicula seleccionada por su id
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    //personalizar estilo de letra
    final textStyle = Theme.of(context).textTheme;

    //evaluacion para verificar si los actores se cargaron correctamente
    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 310,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Container(
            width: 150,
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              //Foto de Actor
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  actor.profilePath,
                  height: 200,
                  fit: BoxFit.fitHeight,
                ),
              ),

              const SizedBox(height: 10),

              //Nombre de actor
              Text(
                actor.name,
                maxLines: 2,
                style: textStyle.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              ),

              //Personaje
              Text(
                actor.character ?? 'Sin personaje.',
                maxLines: 2,
                style: textStyle.titleLarge?.copyWith(
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ]),
          );
        },
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient(
      {this.begin = Alignment.centerLeft,
      this.end = Alignment.centerRight,
      required this.stops,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: begin, end: end, stops: stops, colors: colors))),
    );
  }
}

// return Column(
//   children: [
//     Padding(padding: const EdgeInsets.all(20),
//     child: Column(
//       children: [
//         Text(movie.title, style: textStyle.titleLarge?.copyWith(color: Colors.white60, fontWeight: FontWeight.bold, fontSize:40)),
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: Image.network(movie.posterPath,width: size.width * 0.32),
//             ),
//             const SizedBox(width: 10),
//             SizedBox(
//               width: (size.width - 80) * 0.68,
//               child: Text(movie.overview, style: textStyle.labelSmall?.copyWith(fontSize: 14)),
//             )
//           ],
//         ),
//       ],
//     )),
//     SizedBox(height: 100)
