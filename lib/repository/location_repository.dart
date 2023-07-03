import 'package:geolocator/geolocator.dart';

class LocationRepository {
  final geolocator = Geolocator();

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }
}
