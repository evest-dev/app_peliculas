import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  FullScreenLoader({super.key});

  //Mensajes personalizados de acuerdo a las secciones que tenemos
  final messages = <String>[
    'Cargando la sección de Peliculas',
    'Cargando la sección de Populares',
    'Cargando la sección de Proximamente',
    'Cargando la sección de Hoy',
  ];

  //definimos getLoadingMessages que sera un stream que recorrera todo el arreglo de messages
  Stream<String> getLoadingMessages() {
    //establecemos que cada string se muestre cada 1200 milisegundos
    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      //retornamos el arreglo de acuerdo a la variable step que guarda el tiempo en milisegundos
      return messages[step];
      //definimos la longitud de Strings que hay dentro de messages 
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //definimos el StreamBuilder 
        StreamBuilder(
          stream: getLoadingMessages(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Cargando..');
            return Text(snapshot.data!);
          },
        ),
        const SizedBox(height: 20),
        const CircularProgressIndicator(strokeWidth: 2)
      ],
    ));
  }
}
