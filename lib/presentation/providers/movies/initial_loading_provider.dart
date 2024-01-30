import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movies_providers.dart';

//escuchar multiples providers en simultaneo para validar el loading
final initialLoadingProvider = Provider<bool>((ref) {
  //definimos como steps los providers que hacen peticion http, extraen y muestran los datos esten vacios
  final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
  final step2 = ref.watch(popularMoviesProvider).isEmpty;
  final step3 = ref.watch(upcomingMoviesProvider).isEmpty;
  final step4 = ref.watch(topRatedMoviesProvider).isEmpty;
  //si estan vacios retorna true para iniciar el loading
  if (step1 || step2 || step3 || step4) return true;
  
  //de lo contrario el valor por defecto es false
  return false;
});
