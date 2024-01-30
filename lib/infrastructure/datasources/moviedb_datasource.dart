import 'package:app_peliculas/infrastructure/models/moviedb/movie_details.dart';
import 'package:dio/dio.dart';

import 'package:app_peliculas/config/constants/enviroment.dart';
import 'package:app_peliculas/domain/datasourses/movies_datasources.dart';

import 'package:app_peliculas/infrastructure/mappers/movie_mapper.dart';
import 'package:app_peliculas/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:app_peliculas/domain/entities/movie.dart';
import 'package:flutter/widgets.dart';

class MovieDbDataSource extends MoviesDataSource {
  //Configuracion del cliente http The MovieDb
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Enviroment.ThemovieDBKey,
        'language': 'es-MX'
      }));

  //Metodo que regresa un Listado de Movies Reutilizable
  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    //envolvemos el resultado en JSON
    final movieDBResponse = MovieDbResponse.fromJson(json);

    // Listar las peliculas en base a los resultados
    final List<Movie> movies = movieDBResponse.results

        //verificacion de las peliculas si tienen o no poster y no se rompa por el retorno del String 'no-poster'
        .where((moviedb) => moviedb.posterPath != 'no-poster')

        //mapeo de las peliculas en base al MovieMapper y su entidad
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  }

  //Funcion para obtener las peliculas 'hoy en cines' de forma paginada
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    //Peticion http para obtener las peliculas de la seccion 'hoy en cines'
    final response =
        await dio.get('/movie/now_playing', queryParameters: {'page': page});

    //llamamos al metodo para que retorne el listado de Movies
    return _jsonToMovies(response.data);
  }

  //Funcion para obtener las peliculas 'Populares' de forma paginada
  @override
  Future<List<Movie>> getPoPular({int page = 1}) async {
    //Peticion http para obtener las peliculas de la seccion 'populares'
    final response =
        await dio.get('/movie/popular', queryParameters: {'page': page});

    //llamamos al metodo para que retorne el listado de Movies
    return _jsonToMovies(response.data);
  }

  //Funcion para obtener las peliculas 'Proximamente' de forma paginada
  @override
  Future<List<Movie>> getUpComing({int page = 1}) async {
    final response =
        await dio.get('/movie/upcoming', queryParameters: {'page': page});

    //llamamos al metodo para que retorne el listado de Movies
    return _jsonToMovies(response.data);
  }

  //Funcion para obtener las peliculas 'Top Peliculas' de forma paginada
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response =
        await dio.get('/movie/top_rated', queryParameters: {'page': page});

    //llamamos al metodo para que retorne el listado de Movies
    return _jsonToMovies(response.data);
  }

  //Funcion para obtener la pelicula de acuerdo a su id
  @override
  Future<Movie> getMovieById(String id) async {
    //definicion de ruta
    final response = await dio.get('/movie/$id');

    //validacion de si una pelicula existe por medio de su id
    if (response.statusCode != 200)
      throw Exception('Movie with id: $id not found');

    //definimos el objeto movieDB en donde se almacenara la info de la pelicula seleccionada
    final movieDetails = MovieDetails.fromJson(response.data);

    //Creacion de la entidad del objeto movie en donde se almacenara la info de las peliculas
    final movie = MovieMapper.movieDetailsToEntity(movieDetails);

    //llamamos al metodo para que retorne el listado de Movies
    return movie;
  }

  //Funcion que mostrara las pelicula de acuerdo al query de busqueda
  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];
    //definicion de ruta
    final response =
        await dio.get('/search/movie', queryParameters: {'query': query});

    //validacion de si una pelicula existe de acuerdo al query de busqueda
    if (response.statusCode != 200)
      throw Exception('query movie with id $query not found');

    //llamamos al metodo para que retorne el listado de Movies
    return _jsonToMovies(response.data);
  }
}
