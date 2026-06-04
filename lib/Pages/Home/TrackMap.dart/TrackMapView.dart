// ignore_for_file: file_names, deprecated_member_use, sized_box_for_whitespace, avoid_unnecessary_containers, avoid_print
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:salespersontracking/Style/Stylecustomer.dart';

class TrackMapMain extends StatefulWidget {
  const TrackMapMain({super.key});

  @override
  State<TrackMapMain> createState() => _TrackMapMainState();
}

class _TrackMapMainState extends State<TrackMapMain> {
  String presentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  GoogleMapController? _mapController;
  final Location _locationController = Location();
  LatLng? _currentLocation;

  Set<Polyline> _polylines = {};
  Set<Marker> _customMarkers = {};

  List<Map<String, dynamic>> tripSegments = [];

  List<Map<String, dynamic>> TodayAppointmentList = [
    {
      "Place": "Check In",
      "Time": "09:30",
      "Lat": 12.9560583,
      "Long": 80.2477638
    },
    {
      "Place": "Guindy",
      "Time": "10:30",
      "Distance": "15.05 Km",
      "Lat": 13.0074011,
      "Long": 80.2075338
    },
    {
      "Place": "Porur",
      "Time": "13:30",
      "Distance": "20.02 Km",
      "Lat": 13.0333245,
      "Long": 80.1559066
    },
    {
      "Place": "Check Out",
      "Time": "15:00",
      "Distance": "25.05 Km",
      "Lat": 12.9674235,
      "Long": 80.2039718
    },
  ];

  // -------------------- CURRENT LOCATION --------------------

  void getCurrentLocationmap() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    LocationData locationData = await _locationController.getLocation();

    if (locationData.latitude != null && locationData.longitude != null) {
      _currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentLocation!, zoom: 15),
        ),
      );
    }
  }

  // -------------------- POLYLINE DECODER --------------------

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  // -------------------- ROAD POLYLINES --------------------

  Future<void> generatePolylines() async {
    _polylines.clear();
    tripSegments.clear();

    const String googleApiKey = "AIzaSyDOV_6FRqth9Wj3MFUkHeI_AHTjpOYrze4";

    for (int i = 0; i < TodayAppointmentList.length - 1; i++) {
      final start = TodayAppointmentList[i];
      final end = TodayAppointmentList[i + 1];

      final String url = "https://maps.googleapis.com/maps/api/directions/json"
          "?origin=${start["Lat"]},${start["Long"]}"
          "&destination=${end["Lat"]},${end["Long"]}"
          "&mode=driving"
          "&key=$googleApiKey";

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data["routes"].isNotEmpty) {
        final route = data["routes"][0];
        final leg = route["legs"][0];

        final String encodedPolyline = route["overview_polyline"]["points"];

        final List<LatLng> roadPoints = decodePolyline(encodedPolyline);

        final String distance = leg["distance"]["text"];
        final String duration = leg["duration"]["text"];

        tripSegments.add({
          "from": start["Place"],
          "to": end["Place"],
          "distance": distance,
          "time": duration,
        });

        _polylines.add(
          Polyline(
            polylineId: PolylineId("route_$i"),
            points: roadPoints,
            width: 6,
            color: Colors.blue,

            // ✅ KEEP ROUTE BEHIND MARKERS
            zIndex: 1,
          ),
        );
      }
    }

    setState(() {});
  }

  // -------------------- CUSTOM MARKERS --------------------

  Future<BitmapDescriptor> buildCustomMarker({
    required String title,
    required String distance,
    required String time,
    required bool isStart,
    required bool isEnd,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final Paint paint = Paint()
      ..color = isStart
          ? Stylecustomer.CrmColor
          : isEnd
              ? Colors.red
              : Colors.black;

    const double width = 160;
    const double height = 90;

    final RRect rRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, width, height),
      const Radius.circular(15),
    );

    canvas.drawRRect(rRect, paint);

    TextPainter tp = TextPainter(maxLines: 3);
    tp.text = TextSpan(
      text: "$title\n$distance | $time",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );

    tp.textDirection = ui.TextDirection.ltr;
    tp.layout(maxWidth: width - 20);
    tp.paint(canvas, const Offset(12, 20));

    final image =
        await recorder.endRecording().toImage(width.toInt(), height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  // -------------------- GENERATE CUSTOM MARKERS --------------------

  Future<void> generateCustomTripMarkers() async {
    Set<Marker> markers = {};

    for (int i = 0; i < TodayAppointmentList.length; i++) {
      final data = TodayAppointmentList[i];

      final bool isStart = i == 0;
      final bool isEnd = i == TodayAppointmentList.length - 1;

      final bmp = await buildCustomMarker(
        title: data["Place"],
        distance: data["Distance"] ?? "0 Km",
        time: data["Time"],
        isStart: isStart,
        isEnd: isEnd,
      );

      markers.add(
        Marker(
          markerId: MarkerId("trip_$i"),
          position: LatLng(data["Lat"], data["Long"]),
          icon: bmp,

          // ✅ KEEP MARKERS ABOVE POLYLINE
          zIndex: 1000,

          // ✅ SLIGHTLY FLOAT CONTAINER ABOVE ROAD
          anchor: const Offset(0.5, 1.1),
        ),
      );
    }

    setState(() {
      _customMarkers = markers;
    });
  }

  // -------------------- INIT --------------------

  @override
  void initState() {
    super.initState();
    generatePolylines();
    generateCustomTripMarkers();
  }

  // -------------------- UI (UNCHANGED) --------------------

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: MediaQuery.of(context).size.height * 0.10,
              flexibleSpace: Container(
                height: MediaQuery.of(context).size.height * 0.11,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromRGBO(7, 182, 182, 1),
                      ]),
                ),
                child: Center(
                  child: Text(
                    "Track Appointment",
                    style: Stylecustomer.HeaderTittleText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
            ),
            body: SafeArea(
                child: Column(children: [
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(20.5937, 78.9629),
                        zoom: 5.0,
                      ),
                      zoomControlsEnabled: false,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      onMapCreated: (GoogleMapController controller) async {
                        _mapController = controller;
                        getCurrentLocationmap();
                      },
                      markers: _customMarkers,
                      polylines: _polylines,
                    ),
                    Positioned(
                      top: 15,
                      right: 15,
                      child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Stylecustomer.CrmColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.my_location,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          )),
                    ),
                    DraggableScrollableSheet(
                      initialChildSize: 0.1,
                      minChildSize: 0.1,
                      maxChildSize: 0.7,
                      builder: (context, scrollController) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, -2))
                            ],
                          ),
                          child: ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            children: const [
                              Center(
                                child: Text(
                                  "Trip Plan",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ]))));
  }
}
