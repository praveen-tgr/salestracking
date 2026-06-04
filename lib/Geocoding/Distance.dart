import 'dart:convert';
import 'package:http/http.dart' as http;

Future<double> getRoadDistanceInKm({
  required double startLat,
  required double startLng,
  required double endLat,
  required double endLng,
}) async {
  
  const String apiKey = "AIzaSyCopJnv9knvEA4N0InoBX5sX34411i6vtY";
  // const String apiKey = "AIzaSyDOV_6FRqth9Wj3MFUkHeI_AHTjpOYrze4";

  final String url = "https://maps.googleapis.com/maps/api/distancematrix/json"
      "?origins=$startLat,$startLng"
      "&destinations=$endLat,$endLng"
      "&mode=driving"
      "&key=$apiKey";
  print("Api $url");

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print("Response $data");

    if (data['rows'][0]['elements'][0]['status'] == "OK") {
      final distanceInMeters =
          data['rows'][0]['elements'][0]['distance']['value'];

      return distanceInMeters / 1000; // KM
    } else {
      throw Exception("No route found");
    }
  } else {
    throw Exception("Failed to fetch distance");
  }
}
