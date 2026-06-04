// ignore_for_file: avoid_print

import 'package:geocoding/geocoding.dart';

Future<Map<String, dynamic>> getAddressFromCoordinates(
    double latitude, double longitude) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      return {
        'Street': placemark.street,
        'Locality': placemark.locality,
        'Sublocality': placemark.subLocality,
        'Administrativearea': placemark.administrativeArea,
        'Subadministrativearea': placemark.subAdministrativeArea,
        'Country': placemark.country,
        'Postalcode': placemark.postalCode,
      };
    }
    return {'error': 'Address not found'};
  } catch (e) {
    print("Error: $e");
    return {'error': 'Error occurred during geocoding'};
  }
}
