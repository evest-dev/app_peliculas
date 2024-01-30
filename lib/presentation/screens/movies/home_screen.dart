import 'package:app_peliculas/presentation/views/home_views/favorites_view.dart';
import 'package:app_peliculas/presentation/views/home_views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:app_peliculas/presentation/widgets/shared/custom_bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  final int pageIndex;
  //childView para manejar las rutas

  const HomeScreen({super.key, required this.pageIndex});

  final viewRoutes = const <Widget>[
    HomeView(),
    // SizedBox(), //categoriesView
    // SizedBox(),
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: IndexedStack(
          //redireccionamiento de rutas y el index
          index: pageIndex,
          children: viewRoutes,
        ), 
        bottomNavigationBar: CustomBottomNavigation(currentIndex: pageIndex,));
  }
}
