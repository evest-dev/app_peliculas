import 'package:app_peliculas/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class YearGenStarts extends StatelessWidget {
  const YearGenStarts({
    super.key,
    required this.movie,
  });

  final Movie movie;
 
  @override
  Widget build(BuildContext context) {
    //obtenemos el size para posteriormente colocar la imagen en el size definido
    final size = MediaQuery.of(context).size;
    
    // Funcion para generar estrellas
    List<Icon> generateStars(double valor) {
      int cantidadEstrellas = (valor / 2).floor().clamp(0, 5);
      List<Icon> iconosEstrellas = List.generate(5, (index) {
        return Icon(
          index < cantidadEstrellas ? Icons.star : Icons.star_border_outlined,
          color: Colors.yellow.shade800,
          size: 20,
        );
      });
      return iconosEstrellas;
    }
    
    //Asignar estrellas de acuerdo al puntaje de las movies
    List<Icon> estrellas = generateStars(movie.voteAverage);
    
    return Row(
      children: [
        Text('${DateTime(movie.releaseDate.year).year} •'),
        const SizedBox(width: 4),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.start,
            children: [
              SizedBox(
                width: size.width - 211,
                child: Text(
                  movie.genreIds.join(', '),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Row(children: estrellas)
      ],
    );
  }
}