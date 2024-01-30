import 'package:flutter/material.dart';
import 'package:app_peliculas/presentation/widgets/widgets.dart';
import 'package:app_peliculas/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    //Leemos el notifier del 'nowPlayingMoviesProvider', en este caso el loadloadNextPage
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();

    //Leemos el notifier del 'popularMoviesProvider', en este caso el loadloadNextPage
    ref.read(popularMoviesProvider.notifier).loadNextPage();

    //Leemos el notifier del 'upcomingMoviesProvider', en este caso el loadloadNextPage
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();

    //Leemos el notifier del 'topRatedMoviesProvider', en este caso el loadloadNextPage
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    //definimos con .watch para ver el estado de los multiples providers definido como initialLoadingProvider
    final initialLoading = ref.watch(initialLoadingProvider);

    //validamos, si retorna true (datos vacios) retorna el widget FullScreenLoader, de ser falso muestra todo normal
    if (initialLoading) return FullScreenLoader();

    //Mandamos a llamar en una variable el listado de peliculas del nowPlayingMoviesProvider
    final slideShowMovies = ref.watch(moviesSlideShowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    //usamos CustomScrollView para poder tener el AppBar Flotante
    return CustomScrollView(
      slivers: [
        //AppBar de la app de peliculas
        const SliverAppBar(
          //hacer el appBar Flotante
          floating: true,
          //usamos flexibleSpace para colocar el customAppBar que creamos
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),

        //usamos SliverList para agregar todos los widgets que van en el body de nuestra app de peliculas
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Column(
            children: [
              //Slider de Movies mas vistas
              MovieSlideShow(movies: slideShowMovies),

              //horizontalListView nowPlayingMovies
              MovieHorizontalListView(
                movies: nowPlayingMovies,
                title: 'En Cines',
                subtitle: 'Hoy',
                loadNextPage: () {
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  
                },
              ),

              //horizontalListView popularMovies
              MovieHorizontalListView(
                movies: popularMovies,
                title: 'Populares',
                //subtitle: 'Ahora',
                loadNextPage: () {
                  ref.read(popularMoviesProvider.notifier).loadNextPage();
                },
              ),

              //horizontalListView upcomingMovies
              MovieHorizontalListView(
                movies: upcomingMovies,
                title: 'Proximamente',
                subtitle: 'Sig. Mes',
                loadNextPage: () {
                  ref.read(upcomingMoviesProvider.notifier).loadNextPage();
                },
              ),

              //horizontalListView topRatedMovies
              MovieHorizontalListView(
                movies: topRatedMovies,
                title: 'Top Peliculas',
                loadNextPage: () {
                  ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                },
              )
            ],
          );
        }, childCount: 1))
      ],
    );
  }
}


// Expanded(child:
              //   //Mostramos la data en un ListView
              //   ListView.builder(
              //   //Pasamos del itemCount el la cantidad total de nowPlayingMovies
              //   itemCount: nowPlayingMovies.length,
              //   //Agregamos el itemBuilder en donde pasaremos las peliculas almacenadas en nowPlayingMovies
              //   itemBuilder: (context, index) {
              //     //definimos movie en donde se pasaran de acuerdo al index las peliculas del nowPlayingMovies
              //     final movie = nowPlayingMovies[index];
              //     return ListTile(
              //       title: Text(movie.title),
              //       subtitle: Text(movie.overview),
              //       );
              //     },
              //   )
              // )