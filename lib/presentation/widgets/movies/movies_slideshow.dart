import 'package:app_peliculas/presentation/delegates/search_movie_delegate.dart';
import 'package:app_peliculas/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_peliculas/domain/entities/movie.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieSlideShow extends ConsumerWidget {
  final List<Movie> movies;
  const MovieSlideShow({super.key, required this.movies});

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;

    //responsividad en versiones moviles y de escritorio
    final hasVersion = MediaQuery.of(context).viewPadding.top == 0 ||
        MediaQuery.of(context).viewPadding.top == 24;

    // print('hasVersion $hasVersion');
    return SizedBox(
        height: hasVersion ? 480 : 260,
        width: double.infinity,
        child: Swiper(
            viewportFraction: 0.86,
            scale: 0.92,
            autoplay: true,
            pagination: SwiperPagination(
                margin: const EdgeInsets.only(bottom: 0),
                builder: DotSwiperPaginationBuilder(
                    activeColor: colors.secondary, color: Colors.white10)),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: GestureDetector(
                  onTap: () {
                    final movie = movies[index];
                    context.go('/home/0/movie/${movie.id}');
                  },
                  child: Column(
                    children: [
                      _SlideTitle(movie: movies[index]),
                      Expanded(child: _SlideImage(movie: movies[index])),
                    ],
                  ),
                ),
              );
            }));
  }
}

class _SlideTitle extends StatelessWidget {
  final Movie movie;
  const _SlideTitle({required this.movie});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: DecoratedBox(
        decoration:
            const BoxDecoration(color: Colors.transparent), // Sin decoración
        child: Text(
          movie.title,
          style: titleStyle?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.secondary,
            fontSize: 17,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _SlideImage extends StatelessWidget {
  final Movie movie;
  const _SlideImage({required this.movie});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 10))
      ],
    );

    return DecoratedBox(
      decoration: decoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          movie.backdropPath,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress != null) {
              return const DecoratedBox(
                decoration: BoxDecoration(color: Colors.black12),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return FadeIn(child: child);
          },
        ),
      ),
    );
  }
}
