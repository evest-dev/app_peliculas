import 'package:app_peliculas/config/helpers/humans_formats.dart';
import 'package:app_peliculas/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';

class MovieHorizontalListView extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage;
  const MovieHorizontalListView(
      {super.key,
      required this.movies,
      this.title,
      this.subtitle,
      this.loadNextPage});

  @override
  State<MovieHorizontalListView> createState() =>
      _MovieHorizontalListViewState();
}

class _MovieHorizontalListViewState extends State<MovieHorizontalListView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        print('LoadNextMovies');
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(size);
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          if (widget.title != null || widget.subtitle != null)
            _Title(title: widget.title, subtitle: widget.subtitle),
          Expanded(
              child: ListView.builder(
            controller: scrollController,
            itemCount: widget.movies.length,
            //mismo scroll en ambas plataformas
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return FadeIn(child: _Slide(movie: widget.movies[index]));
            },
          ))
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

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
    
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.only(top: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                width: 158,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    const Center(
                        child: CircularProgressIndicator(strokeWidth: 2));
                  }
                  //Pasarle el Id de la pelicula al darle click en cualquier imagen del listado de peliculas
                  return GestureDetector(
                      onTap: () => context.go('/home/0/movie/${movie.id}'),
                      child: FadeIn(
                          duration: const Duration(milliseconds: 1000),
                          child: child));
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
              width: 160,
              child: Text(movie.title,
                  maxLines: 1,
                  style: textStyle.titleSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15), overflow: TextOverflow.ellipsis)),
          const SizedBox(height: 5),

          SizedBox(
            width: 156,
            child: Row(
              children: [
                Row(children: estrellas),
                const Spacer(),
                Icon(Icons.language, color: colors.secondary, size: 18),
                Text(movie.originalLanguage.toUpperCase(),
                    style: textStyle.bodyMedium?.copyWith(
                        color: colors.secondary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
         
          const SizedBox(height: 5),
          //conversion a K por cada 1000 en formato 'en' usando itln y el formater 'HumanFormats'
          SizedBox(
              width: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text('${DateTime(movie.releaseDate.year).year} • ', style: const TextStyle(fontSize: 13.8)),
                  
                  Text('${HumanFormats.number(movie.popularity)} Me Gusta',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13.8)
                      ),
                ],
              )),
        ]));
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subtitle;
  const _Title({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(color: colors.secondary);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null)
            Text(title!,
                style: titleStyle?.copyWith(
                    fontWeight: FontWeight.w600, fontSize: 17)),
          const Spacer(),
          if (subtitle != null)
            FilledButton.tonal(
                onPressed: () {},
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                child: Text(subtitle!,
                    style: titleStyle?.copyWith(
                        fontSize: 14, fontWeight: FontWeight.w500)))
      ]),
    );
  }
}
