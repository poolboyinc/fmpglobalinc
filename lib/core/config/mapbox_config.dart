import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapboxConfig {
  static String get accessToken => dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
  static const String styleUrl =
      'mapbox://styles/poolboiinc/cm9typgs800co01s5d9eb5752';

  static const double initialLatitude = 44.786568;
  static const double initialLongitude = 20.448922;
  static const double initialZoom = 12.0;
}
