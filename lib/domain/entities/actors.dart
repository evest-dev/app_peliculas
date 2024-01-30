import 'package:flutter/material.dart';

class Actor {
  final int id;
  final String name;
  final String profilePath;
  final String? character;
  final String? knownForDepartment;
  final double? popularity;

  Actor(
      {required this.id,
      required this.name,
      required this.profilePath,
      required this.character,
      required this.knownForDepartment,
      required this.popularity
  });
}
