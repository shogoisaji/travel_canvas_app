import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<void> permissionCheck() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<Position?> getPosition() async {
    permissionCheck();
    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print("Error getting position: $e");
    }
    return null;
  }

  Future<String> jsonPosition() async {
    Position? position = await getPosition();
    if (position == null) return '';
    Map<String, dynamic> positionMap = {
      'latitude': position.latitude,
      'longitude': position.longitude
    };
    return jsonEncode(positionMap);
  }

  Future<String> getAddress() async {
    try {
      final currentPosition = await getPosition();
      if (currentPosition == null) return '';
      final lat = currentPosition.latitude;
      final lon = currentPosition.longitude;

      final placemarks =
          await placemarkFromCoordinates(lat, lon, localeIdentifier: 'ja');
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.administrativeArea}  ${place.locality}  ${place.subLocality}';
      }
    } catch (e) {
      print("Error getting address: $e");
    }
    return '';
  }
}
