import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static String ThemovieDBKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No API Key';
}
