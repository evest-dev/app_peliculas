import 'package:app_peliculas/infrastructure/datasources/isar_datasource.dart';
import 'package:app_peliculas/infrastructure/repositories/local_storage_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Crea la instancia de nuestro repositorio el cual tiene todos los metodos que necesitamos

final localStorageRepositoryProvider = Provider((ref) {
  return LocalStorageRepositoryImpl(IsarDataSource());
});

