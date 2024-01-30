import 'package:app_peliculas/domain/entities/movie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class MoviePosterLink extends StatelessWidget {
  final Movie movie;
  const MoviePosterLink({
    required this.movie,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:10, left: 8, right: 8),
      child: FadeInUp(
        child: GestureDetector(
          onTap: ()=>context.go('/home/0/movie/${movie.id}'),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(movie.posterPath),
                ),
                const SizedBox(height: 10),
                Text(movie.title),
            ],
          ),
        ),
        )
    );
  }
}
