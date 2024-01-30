import 'package:go_router/go_router.dart';
import 'package:app_peliculas/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0', 
  routes: [
    GoRoute(
      //Rutas generales de acuerdo al page
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = state.pathParameters['page'] ?? '0';
        return HomeScreen(pageIndex: int.parse(pageIndex));
      },

      routes: [
      //obtener el Id cada pelicula que estan en una lista
      GoRoute(
        path: 'movie/:id',
        name: MovieScreen.name,
        builder: (context, state) {
          final movieId = state.pathParameters['id'] ?? 'no-id';
          return MovieScreen(movieId: movieId);
        },
      )
    ]),

    //Redireccionar a la ruta home/0
    GoRoute(path: '/',
      redirect: (_, __) => '/home/0')
  ]
);
