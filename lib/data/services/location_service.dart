import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {

  /// 🔐 Check + request permission properly
  static Future<void> _ensurePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location service is disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }
  }

  /// 📍 Get GPS position (with timeout)
  static Future<Position> getCurrentPosition() async {
    await _ensurePermission();

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10), // ⏱ prevents infinite loading
    );
  }

  /// 🏠 Convert GPS → Address
  static Future<String> getCurrentAddress() async {
    try {
      final position = await getCurrentPosition();

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        return 'Unknown location';
      }

      final p = placemarks.first;

      return [
        p.street,
        p.subLocality,
        p.locality,
      ].where((e) => e != null && e!.isNotEmpty).join(', ');
    } catch (e) {
      return 'Unable to get location';
    }
  }
}
