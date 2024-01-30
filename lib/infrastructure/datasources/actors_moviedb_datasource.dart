import 'package:app_peliculas/config/constants/enviroment.dart';
import 'package:app_peliculas/domain/datasourses/actors_datasources.dart';
import 'package:app_peliculas/domain/entities/actors.dart';
import 'package:app_peliculas/infrastructure/mappers/actor_mapper.dart';
import 'package:app_peliculas/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

//Implementacion de los actores por el movieId seleccionada
class ActorMovieDbDataSource extends ActorsDatasource {
  Future<List<Actor>> getActorsByMovie(String movieId) async {

  //Configuracion del cliente http The MovieDb
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Enviroment.ThemovieDBKey,
        'language': 'es-MX'
      }));
    
    //definicion de ruta de actores
    final response = await dio.get('/movie/$movieId/credits');

    //validacion de si existen los actores por medio de su id
    if (response.statusCode != 200) throw Exception('Movie with id: $movieId not found');

    //definimos el objeto castResponse en donde se almacenara la info de los actores de la movie seleccionada
    final castResponse = CreditsResponse.fromJson(response.data);

    //Creacion de la entidad del objeto actors en donde se almacenara la lista de actores de la movie seleccionada
    List<Actor> actors = castResponse.cast.map(
      (cast) => ActorMapper.castToEntity(cast)
      ).toList();
    
    //llamamos al metodo para que retorne el listado de Movies
    return actors;
  
  }

}
