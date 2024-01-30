import 'package:app_peliculas/domain/entities/actors.dart';
import 'package:app_peliculas/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {
    static Actor castToEntity(Cast cast) => Actor(
      id: cast.id,
      name: cast.name,
      profilePath: cast.profilePath != null
      ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
      : 'https://icon2.cleanpng.com/20180401/goe/kisspng-user-profile-computer-icons-profile-5ac09244d91906.2547020615225697968892.jpg',
      character : cast.character,
      knownForDepartment: cast.knownForDepartment,
      popularity: cast.popularity
      );
}
