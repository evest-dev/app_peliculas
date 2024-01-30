import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavigation({super.key, required this.currentIndex});

  //funcion para determinar la direccion de la ruta ya sea 0,1,2
  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home/0');
        break;
      // case 1:
      //   context.go('/home/1');
      //   break;
      // case 2:
      //   context.go('/home/2');
      //   break;
      case 1:
        context.go('/home/1');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

      //currentIndex tomara la posicion de la ruta, en este caso si es home/0, home/1 etc
      currentIndex: currentIndex,
      
      //onItemTapped le pasaremos el context y value para determinar la ruta al precionar los tabs del bottomNavigatorBar
      onTap: (value) => onItemTapped(context, value),
      
      elevation: 1,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded), label: 'Favoritos'),
        // BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Busqueda'),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.video_label_rounded), label: 'Categorias'),

       

      ],
    );
  }
}
