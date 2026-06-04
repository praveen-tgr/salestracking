// ignore_for_file: file_names, deprecated_member_use, sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:salespersontracking/ApiConfig/ApiConfig.dart';
import 'package:salespersontracking/Controller/Network/NetworkController.dart';
import 'package:salespersontracking/Controller/Network/NetworkerroPage.dart';
import 'package:salespersontracking/Providers/Home/home_provider.dart';
import 'package:salespersontracking/Providers/Auth/auth_provider.dart';
import 'package:salespersontracking/Geocoding/Address.dart';
import 'package:salespersontracking/Geocoding/Distance.dart';
import 'package:salespersontracking/Validation/ToastMessage.dart';
import 'package:salespersontracking/Pages/Home/Appointment/AppointmentCreate.dart';
import 'package:salespersontracking/Pages/Home/Appointment/AppointmentList.dart';
import 'package:salespersontracking/Pages/Home/TrackMap.dart/TrackMapView.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:salespersontracking/Style/TextFieldStyle.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart' as p;
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  String PresentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool ShowActivity = true;
  bool ShowAppointment = false;
  List<Map<String, dynamic>> OverallActivity = [];
  List<Map<String, dynamic>> OverallAppointment = [];
  List<Map<String, dynamic>> PresentDateCheckInData = [];

  // Trip Tracker State
  List<Map<String, dynamic>> _tripSteps = [];
  double _totalDistance = 0.0;
  bool _isCalculatingTrip = false;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  GoogleMapController? _tripMapController;

  final String _mapStyle = '''
  [
    {"elementType": "geometry", "stylers": [{"color": "#f5f5f5"}]},
    {"elementType": "labels.icon", "stylers": [{"visibility": "off"}]},
    {"elementType": "labels.text.fill", "stylers": [{"color": "#616161"}]},
    {"elementType": "labels.text.stroke", "stylers": [{"color": "#f5f5f5"}]},
    {"featureType": "poi", "elementType": "geometry", "stylers": [{"color": "#eeeeee"}]},
    {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#ffffff"}]},
    {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#dadada"}]},
    {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#d4f1f1"}]}
  ]
  ''';

  List<String> CustomerList = [];
  List<Map<String, dynamic>> TodayAppointmentList = [];
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  TextEditingController SalesPersonName = TextEditingController();

  bool Isloading_MasterCheck = true;

  List<Map<String, dynamic>> ListAppointment = [];

  bool CheckIn_Loading = true;
  bool Appointment_CheckIn_Loading = true;
  bool Appointment_CheckIn = true;
  bool _isAttendanceToggleLoading = false;

  int? User_Id;
  int? Organization_Id;
  String? Terant;
  String? username;
  String? Token;
  String? Designation;

  final Location _locationController = Location();
  LatLng? CurrentPosition;
  String Check_Place = "";

  String selectedDate = "";

  // Legacy method kept for some logic, but replaced by Riverpod in UI
  void ChackCurrentCheckIn() async {
    // This is now handled by currentCheckInProvider
  }

  Future<void> Handle_Refresh() async {
    // Riverpod handles refresh via ref.invalidate
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferencesValues();
  }

  Future<void> getSharedPreferencesValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      User_Id = prefs.getInt('User_Id') ?? 0;
      Organization_Id = prefs.getInt('Organization_Id') ?? 0;
      Terant = prefs.getString('Terant') ?? "";
      username = prefs.getString('username') ?? "";
      Token = prefs.getString('Token') ?? "";
      Designation = prefs.getString('Designation') ?? "";
    });
  }

  Future<bool> checkAndFetchCurrentLocation() async {
    try {
      bool serviceEnabled = await _locationController.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationController.requestService();
        if (!serviceEnabled) return false;
      }

      PermissionStatus permissionGranted = await _locationController
          .hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _locationController.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return false;
      }

      final locationData = await _locationController.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          CurrentPosition = LatLng(
            locationData.latitude!,
            locationData.longitude!,
          );
        });
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> HandleCheckIn(String time) async {
    if (_isAttendanceToggleLoading) return;
    setState(() => _isAttendanceToggleLoading = true);
    try {
      bool locationReady = await checkAndFetchCurrentLocation();
      if (!locationReady) {
        ErrorToast.showToast(
          context: context,
          title: 'Location Error',
          description: 'Unable to fetch location. Please enable GPS.',
        );
        return;
      }

      final addressData = await getAddressFromCoordinates(
        CurrentPosition!.latitude,
        CurrentPosition!.longitude,
      );
      final String place =
          addressData['Locality'] ?? addressData['Sublocality'] ?? "Unknown";

      final userAsync = ref.read(userDataProvider);
      userAsync.whenData((userData) async {
        final String presentDate = DateFormat(
          'yyyy-MM-dd',
        ).format(DateTime.now());

        final payload = {
          "Employee_name": userData['username'],
          "Date": presentDate,
          "Checkin_Date": presentDate,
          "Checkout_Date": null,
          "Checkin_Time": time,
          "Checkout_Time": null,
          "Checkin_Place": place,
          "Checkout_Place": "",
          "Checkin_Latitude": CurrentPosition?.latitude ?? 0.0,
          "Checkin_Longitude": CurrentPosition?.longitude ?? 0.0,
          "Checkout_Latitude": 0.0,
          "Checkout_Longitude": 0.0,
          "Location": place,
          "Total_distance": "",
          "Total_apointmnets": 0,
          "Shift": "Morning",
          "Year": DateTime.now().year,
          "Month": DateFormat('MMMM').format(DateTime.now()),
          "Working_Hours": 0,
          "Checkin_Flag": true,
          "Checkout_Flag": false,
          "Present_Flag": true,
          "Approved_Flag": false,
          "Timesheet_Flag": true,
          "Checkin_Orgin": "Mobile",
          "Is_Deleted": false,
          "User_Id": userData['User_Id'],
          "Created_By": userData['User_Id'],
          "Created_Date": presentDate,
          "Company_Id": null,
        };

        try {
          await ref
              .read(homeDataProvider.notifier)
              .checkIn(payload, userData['Terant']);
          ref.invalidate(
            currentCheckInProvider(
              userId: userData['User_Id'],
              terant: userData['Terant'],
            ),
          );
          SuccessToast.showToast(
            context: context,
            title: 'Success',
            description: 'Checked In Successfully!',
          );
        } catch (e) {
          ErrorToast.showToast(
            context: context,
            title: 'Check-in Error',
            description: 'Check-in failed: $e',
          );
        }
      });
    } finally {
      if (mounted) {
        setState(() => _isAttendanceToggleLoading = false);
      }
    }
  }

  Future<void> HandleCheckOut(String time) async {
    if (_isAttendanceToggleLoading) return;
    setState(() => _isAttendanceToggleLoading = true);
    try {
      bool locationReady = await checkAndFetchCurrentLocation();
      if (!locationReady) return;

      final addressData = await getAddressFromCoordinates(
        CurrentPosition!.latitude,
        CurrentPosition!.longitude,
      );
      final String place =
          addressData['Locality'] ?? addressData['Sublocality'] ?? "Unknown";

      final userAsync = ref.read(userDataProvider);
      final userValue = userAsync.value;
      if (userValue == null) return;

      final checkInAsync = ref.read(
        currentCheckInProvider(
          userId: userValue['User_Id'],
          terant: userValue['Terant'],
        ),
      );

      checkInAsync.whenData((data) async {
        final results = data['results'] as List? ?? [];
        if (results.isEmpty) return;

        final existingData = results[0];
        final String presentDate = DateFormat(
          'yyyy-MM-dd',
        ).format(DateTime.now());
        final int apptCount = _tripSteps
            .where((s) => s['type'] == 'appointment')
            .length;

        final payload = {
          "id": existingData['id'],
          "Employeecheckin_Id": existingData['Employeecheckin_Id'],
          "Checkout_Date": presentDate,
          "Checkout_Time": time,
          "Checkout_Place": place,
          "Checkout_Latitude": CurrentPosition?.latitude ?? 0.0,
          "Checkout_Longitude": CurrentPosition?.longitude ?? 0.0,
          "Total_distance": _totalDistance.toStringAsFixed(2),
          "Total_apointmnets": apptCount,
          "Working_Hours": _calculateWorkingHours(
            existingData['Checkin_Time'],
            time,
          ),
          "Checkout_Flag": true,
          "Present_Flag": true,
          "Approved_Flag": false,
          "Timesheet_Flag": true,
          "Is_Deleted": false,
          "User_Id": userValue['User_Id'],
          "Created_Date": presentDate,
          "Company_Id": null,
        };

        try {
          await ref
              .read(homeDataProvider.notifier)
              .checkOut(payload, userValue['Terant']);
          ref.invalidate(
            currentCheckInProvider(
              userId: userValue['User_Id'],
              terant: userValue['Terant'],
            ),
          );
          SuccessToast.showToast(
            context: context,
            title: 'Success',
            description: 'Checked Out Successfully!',
          );
        } catch (e) {
          ErrorToast.showToast(
            context: context,
            title: 'Check-out Error',
            description: 'Check-out failed: $e',
          );
        }
      });
    } finally {
      if (mounted) {
        setState(() => _isAttendanceToggleLoading = false);
      }
    }
  }

  double _calculateWorkingHours(String? checkInTime, String checkOutTime) {
    if (checkInTime == null) return 0;
    try {
      final format = DateFormat("HH:mm:ss");
      final start = format.parse(checkInTime);
      final end = format.parse(checkOutTime);
      final diff = end.difference(start);
      return diff.inMinutes / 60.0;
    } catch (_) {
      return 0;
    }
  }

  void _showSimpleModalDialog(
    BuildContext context,
    String condition,
    String message,
    bool isCheckIn,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        content: Text(condition),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  LatLng? _getLatLng(Map<String, dynamic> item) {
    final lat =
        _parseDouble(item['Latitude']) ??
        _parseDouble(item['latitude']) ??
        _parseDouble(item['Lat']) ??
        _parseDouble(item['Checkin_Latitude']) ??
        _parseDouble(item['Checkout_Latitude']);
    final lng =
        _parseDouble(item['Longitude']) ??
        _parseDouble(item['longitude']) ??
        _parseDouble(item['Lng']) ??
        _parseDouble(item['Checkin_Longitude']) ??
        _parseDouble(item['Checkout_Longitude']);
    if (lat != null && lng != null) return LatLng(lat, lng);
    return null;
  }

  Future<void> _calculateTripData(
    List? checkInResults,
    List appointments,
  ) async {
    if (checkInResults == null || checkInResults.isEmpty) {
      if (mounted) setState(() => _tripSteps = []);
      return;
    }

    final List<Map<String, dynamic>> steps = [];
    final checkInData = checkInResults[0];

    // 1. Check-in Step
    final checkInLoc = _getLatLng(checkInData);
    if (checkInLoc != null) {
      steps.add({
        'title': 'Check-in',
        'subtitle': checkInData['Checkin_Place'] ?? 'Unknown',
        'time': checkInData['Checkin_Time'] ?? '--:--',
        'latLng': checkInLoc,
        'type': 'checkin',
      });
    }

    // 2. Appointment Steps
    for (var appt in appointments) {
      final loc = _getLatLng(appt);
      if (loc != null) {
        steps.add({
          'title': appt['Customer_Name'] ?? appt['Subject'] ?? 'Appointment',
          'subtitle': appt['Venue'] ?? appt['Location'] ?? 'Unknown',
          'time': appt['Meeting_Time'] ?? '--:--',
          'latLng': loc,
          'type': 'appointment',
        });
      }
    }

    // 3. Check-out Step
    if (checkInData['Checkout_Time'] != null) {
      final checkOutLoc = LatLng(
        _parseDouble(checkInData['Checkout_Latitude']) ?? 0,
        _parseDouble(checkInData['Checkout_Longitude']) ?? 0,
      );
      if (checkOutLoc.latitude != 0) {
        steps.add({
          'title': 'Check-out',
          'subtitle': checkInData['Checkout_Place'] ?? 'Unknown',
          'time': checkInData['Checkout_Time'],
          'latLng': checkOutLoc,
          'type': 'checkout',
        });
      }
    }

    // Calculate Distances
    double totalDist = 0.0;
    for (int i = 0; i < steps.length - 1; i++) {
      try {
        double dist = await getRoadDistanceInKm(
          startLat: steps[i]['latLng'].latitude,
          startLng: steps[i]['latLng'].longitude,
          endLat: steps[i + 1]['latLng'].latitude,
          endLng: steps[i + 1]['latLng'].longitude,
        );
        steps[i]['nextDist'] = dist;
        totalDist += dist;
      } catch (e) {
        steps[i]['nextDist'] = 0.0;
      }
    }

    if (mounted) {
      setState(() {
        _tripSteps = steps;
        _totalDistance = totalDist;
        _markers = steps
            .map(
              (s) => Marker(
                markerId: MarkerId(s['title'] + s['time']),
                position: s['latLng'],
                infoWindow: InfoWindow(title: s['title'], snippet: s['time']),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  s['type'] == 'checkin'
                      ? BitmapDescriptor.hueGreen
                      : s['type'] == 'checkout'
                      ? BitmapDescriptor.hueRed
                      : BitmapDescriptor.hueAzure,
                ),
              ),
            )
            .toSet();
        _polylines = {
          Polyline(
            polylineId: const PolylineId('trip_path'),
            points: steps.map((s) => s['latLng'] as LatLng).toList(),
            color: Stylecustomer.CrmColor,
            width: 4,
          ),
        };
      });
      _fitTripBounds();
    }
  }

  void _fitTripBounds() {
    if (_tripMapController == null || _tripSteps.isEmpty) return;
    double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;
    for (var step in _tripSteps) {
      final latLng = step['latLng'] as LatLng;
      if (latLng.latitude < minLat) minLat = latLng.latitude;
      if (latLng.latitude > maxLat) maxLat = latLng.latitude;
      if (latLng.longitude < minLng) minLng = latLng.longitude;
      if (latLng.longitude > maxLng) maxLng = latLng.longitude;
    }
    _tripMapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userDataProvider);

    return userAsync.when(
      data: (userData) {
        final userId = userData['User_Id'] as int;
        final terant = userData['Terant'] as String;
        final designation = userData['Designation'] as String;
        final username = userData['username'] as String? ?? "User";

        final checkInAsync = ref.watch(
          currentCheckInProvider(userId: userId, terant: terant),
        );
        final isConnected = p.Provider.of<ConnectivityService>(
          context,
        ).isConnected;

        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: const Color(0xFFFBFBFB),
            extendBodyBehindAppBar: true,
            body: isConnected
                ? RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(
                        currentCheckInProvider(userId: userId, terant: terant),
                      );
                      ref.invalidate(
                        appointmentListProvider(
                          userId: userId,
                          terant: terant,
                          date: PresentDate,
                        ),
                      );
                    },
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        _buildTopBar(username, checkInAsync),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                _buildCheckInMetricsSection(checkInAsync),
                                const SizedBox(height: 30),
                                _buildPendingAppointmentsSection(
                                  userId,
                                  terant,
                                ),
                                const SizedBox(height: 30),
                                _buildTripTrackerSection(userId, terant),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : NoInternetWidget(onRetry: () => setState(() {})),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }

  Widget _buildTopBar(
    String username,
    AsyncValue<Map<String, dynamic>> checkInAsync,
  ) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      expandedHeight: 140, // Reduced from 140 if needed, but keeping for now
      floating: true,
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Stylecustomer.CrmColor.withOpacity(0.15), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(10, 50, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/CRMFARM_LOGO.png',
                    height: 35,
                    fit: BoxFit.contain,
                  ),
                  Row(
                    children: [
                      _buildIconButton(Icons.search),

                      const SizedBox(width: 12),
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Stylecustomer.CrmColor,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Welcome back,",
                          style: Stylecustomer.DashboardSubHeaderStyle,
                        ),
                        Text(
                          username,
                          style: Stylecustomer.DashboardHeaderStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildAttendanceToggle(checkInAsync),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceToggle(AsyncValue<Map<String, dynamic>> checkInAsync) {
    final bool isCheckedIn = checkInAsync.maybeWhen(
      data: (data) => (data['results'] as List? ?? []).isNotEmpty,
      orElse: () => false,
    );

    return GestureDetector(
      onTap: _isAttendanceToggleLoading
          ? null
          : () {
              if (isCheckedIn) {
                HandleCheckOut(DateFormat('HH:mm:ss').format(DateTime.now()));
              } else {
                HandleCheckIn(DateFormat('HH:mm:ss').format(DateTime.now()));
              }
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 100,
        height: 45,
        decoration: BoxDecoration(
          color: isCheckedIn
              ? Stylecustomer.CrmColor.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCheckedIn ? Stylecustomer.CrmColor : Colors.grey[400]!,
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: isCheckedIn ? 53 : 4,
              top: 3,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: isCheckedIn
                      ? Stylecustomer.CrmColor
                      : Colors.grey[400],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _isAttendanceToggleLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : Icon(
                        isCheckedIn ? Icons.check : Icons.power_settings_new,
                        color: Colors.white,
                        size: 14,
                      ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  left: isCheckedIn ? 0 : 25,
                  right: isCheckedIn ? 25 : 0,
                ),
                child: Text(
                  isCheckedIn ? "IN" : "OUT",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isCheckedIn ? Colors.green : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.black87, size: 24),
    );
  }

  Widget _buildPendingAppointmentsSection(int userId, String terant) {
    final appointmentsAsync = ref.watch(
      appointmentListProvider(
        userId: userId,
        terant: terant,
        date: PresentDate,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Pending Appointments",
              style: Stylecustomer.HeaderTittleText16,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppointmentCreate(),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Stylecustomer.CrmColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: Stylecustomer.CrmColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AppointmentList(Navigation: 0, TabIndex: 0),
                    ),
                  ),
                  child: Text("View All", style: Stylecustomer.Textstyle12blue),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 120,
          child: appointmentsAsync.when(
            data: (appointments) {
              if (appointments.isEmpty) {
                return _buildEmptyStateCard("No pending appointments today");
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appt = appointments[index];
                  return Container(
                    width: 250,
                    margin: const EdgeInsets.only(right: 15),
                    padding: const EdgeInsets.all(16),
                    decoration: Stylecustomer.PendingAppointmentDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          appt['Customer_Name'] ?? 'Unnamed Customer',
                          style: Stylecustomer.WhiteText14W600,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appt['Meeting_Time'] ?? 'Time TBD',
                          style: Stylecustomer.WhiteText12W500,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                appt['Location'] ?? 'Remote',
                                style: Stylecustomer.WhiteText12W500,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => _buildShimmerLoading(),
            error: (e, s) => Text("Error loading appointments"),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckInMetricsSection(
    AsyncValue<Map<String, dynamic>> checkInAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Attendance details", style: Stylecustomer.HeaderTittleText16),
        const SizedBox(height: 15),
        checkInAsync.when(
          data: (data) {
            final results = data['results'] as List? ?? [];
            final bool isCheckedIn = results.isNotEmpty;

            final String checkInTime = isCheckedIn
                ? results[0]['Checkin_Time'] ?? '--:--'
                : '--:--';
            final String checkInPlace = isCheckedIn
                ? results[0]['Checkin_Place'] ?? 'Not found'
                : '-';

            final String? checkOutTime = isCheckedIn
                ? results[0]['Checkout_Time']
                : null;
            final String checkOutPlace = (isCheckedIn && checkOutTime != null)
                ? (results[0]['Checkout_Place'] ?? 'Not found')
                : (isCheckedIn ? 'Not Checked Out' : '-');

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildDetailCard(
                    "Check In",
                    checkInTime,
                    checkInPlace,
                    Icons.login,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: _buildCenterStatusCard(
                    isCheckedIn,
                    checkInTime,
                    checkOutTime,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: _buildDetailCard(
                    "Check Out",
                    checkOutTime ?? "--:--",
                    checkOutPlace,
                    Icons.logout,
                    Colors.red,
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => const Text("Error loading metrics"),
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    String title,
    String time,
    String place,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: Stylecustomer.DashboardCardDecoration,
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            time,
            style: Stylecustomer.BlackText14W600,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            place,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCenterStatusCard(
    bool isCheckedIn,
    String checkInTime,
    String? checkOutTime,
  ) {
    bool isCompleted = isCheckedIn && checkOutTime != null;
    String status = !isCheckedIn
        ? "Offline"
        : (isCompleted ? "Completed" : "Active");
    Color statusColor = !isCheckedIn
        ? Colors.grey
        : (isCompleted ? Colors.blue : Colors.green);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: Stylecustomer.DashboardCardDecoration,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (!isCheckedIn)
            const Text(
              "00:00:00",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            )
          else
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Text(
                  _calculateLiveDuration(checkInTime, checkOutTime),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                );
              },
            ),
          const SizedBox(height: 4),
          Text("Duration", style: Stylecustomer.Textstyle12black70weight400),
        ],
      ),
    );
  }

  String _calculateLiveDuration(String inTime, String? outTime) {
    try {
      final now = DateTime.now();
      final format = DateFormat("HH:mm:ss");
      final startTime = format.parse(inTime);
      final startDt = DateTime(
        now.year,
        now.month,
        now.day,
        startTime.hour,
        startTime.minute,
        startTime.second,
      );

      DateTime endDt;
      if (outTime != null && outTime.isNotEmpty) {
        final endTime = format.parse(outTime);
        endDt = DateTime(
          now.year,
          now.month,
          now.day,
          endTime.hour,
          endTime.minute,
          endTime.second,
        );
      } else {
        endDt = now;
      }

      final diff = endDt.difference(startDt);
      if (diff.isNegative) return "00:00:00";

      String twoDigits(int n) => n.toString().padLeft(2, "0");
      return "${twoDigits(diff.inHours)}:${twoDigits(diff.inMinutes.remainder(60))}:${twoDigits(diff.inSeconds.remainder(60))}";
    } catch (_) {
      return "00:00:00";
    }
  }

  Widget _buildTripTrackerSection(int userId, String terant) {
    final checkInAsync = ref.watch(
      currentCheckInProvider(userId: userId, terant: terant),
    );
    final appointmentsAsync = ref.watch(
      appointmentListProvider(
        userId: userId,
        terant: terant,
        date: PresentDate,
      ),
    );

    return checkInAsync.when(
      data: (checkInData) {
        final checkInResults = checkInData['results'] as List?;
        return appointmentsAsync.when(
          data: (appointments) {
            // Trigger calculation if not already done or data changed
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_isCalculatingTrip &&
                  _tripSteps.isEmpty &&
                  (checkInResults?.isNotEmpty ?? false)) {
                _calculateTripData(checkInResults, appointments);
              }
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Live Trip Tracker",
                      style: Stylecustomer.HeaderTittleText16,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Stylecustomer.CrmColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${_totalDistance.toStringAsFixed(1)} KM Total",
                        style: TextStyle(
                          color: Stylecustomer.CrmColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Mini Map
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(20.5937, 78.9629),
                        zoom: 5,
                      ),
                      onMapCreated: (c) {
                        _tripMapController = c;
                        _tripMapController?.setMapStyle(_mapStyle);
                        _fitTripBounds();
                      },
                      markers: _markers,
                      polylines: _polylines,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Timeline
                if (_tripSteps.isEmpty)
                  Center(
                    child: Text(
                      "Start your journey by checking in",
                      style: Stylecustomer.Textstyle14Grey,
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _tripSteps.length,
                    itemBuilder: (context, index) {
                      final step = _tripSteps[index];
                      final isLast = index == _tripSteps.length - 1;
                      final nextDist = step['nextDist'] as double?;

                      return TimelineTile(
                        alignment: TimelineAlign.start,
                        isFirst: index == 0,
                        isLast: isLast,
                        indicatorStyle: IndicatorStyle(
                          width: 30,
                          height: 30,
                          indicator: _buildTimelineIndicator(step['type']),
                          drawGap: true,
                        ),
                        beforeLineStyle: const LineStyle(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        afterLineStyle: const LineStyle(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        endChild: Container(
                          padding: const EdgeInsets.fromLTRB(16, 20, 0, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      step['title'],
                                      style: Stylecustomer.BlackText14W600,
                                    ),
                                  ),
                                  Text(
                                    step['time'],
                                    style: Stylecustomer
                                        .Textstyle12black70weight400,
                                  ),
                                ],
                              ),
                              Text(
                                step['subtitle'],
                                style:
                                    Stylecustomer.Textstyle12black70weight400,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (!isLast && nextDist != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.directions_car,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${nextDist.toStringAsFixed(1)} km to next stop",
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => const Text("Error loading trip appointments"),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const Text("Error loading trip summary"),
    );
  }

  Widget _buildTimelineIndicator(String type) {
    IconData icon;
    Color color;
    switch (type) {
      case 'checkin':
        icon = Icons.login;
        color = Colors.green;
        break;
      case 'checkout':
        icon = Icons.logout;
        color = Colors.red;
        break;
      default:
        icon = Icons.business;
        color = Stylecustomer.CrmColor;
    }
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }

  Widget _buildMapTrackSection() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TrackMapMain()),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: Stylecustomer.DashboardCardDecoration.copyWith(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.05),
              Colors.black.withOpacity(0.02),
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Stylecustomer.CrmColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.map_outlined,
                color: Stylecustomer.CrmColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Track on Map", style: Stylecustomer.BlackText16W600),
                  Text(
                    "Live sales person tracking",
                    style: Stylecustomer.Textstyle12black70weight400,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateCard(String message) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: Stylecustomer.DashboardCardDecoration,
      child: Text(message, style: Stylecustomer.Textstyle14Grey),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer(
      child: Container(
        width: 250,
        decoration: Stylecustomer.DashboardCardDecoration,
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
