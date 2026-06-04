// ignore_for_file: file_names, deprecated_member_use, sized_box_for_whitespace, avoid_unnecessary_containers, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:salespersontracking/ApiConfig/ApiConfig.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tracking extends StatefulWidget {
  const Tracking({super.key});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  String Presentdate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool isLoading = true;
  int? User_Id;
  int? Organization_Id;
  String? Terant;
  String? Roll_Name;
  List<Map<String, dynamic>> ListLead = [];
  
  GoogleMapController? _mapController;
  String _selectedDropdownValue = 'All';
  Map<String, dynamic>? _selectedCustomerData;

  // Swiggy-like minimalist map style matching CRM brand
  final String _mapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [{"color": "#f5f5f5"}]
    },
    {
      "elementType": "labels.icon",
      "stylers": [{"visibility": "off"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#616161"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#f5f5f5"}]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#bdbdbd"}]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [{"color": "#eeeeee"}]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [{"color": "#ffffff"}]
    },
    {
      "featureType": "road.arterial",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#757575"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [{"color": "#dadada"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#616161"}]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [{"color": "#d4f1f1"}]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#9e9e9e"}]
    }
  ]
  ''';


  // Helper to safely parse lat/lng keys as they might be differently cased
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  LatLng? _getLatLng(Map<String, dynamic> item) {
    final lat = _parseDouble(item['Latitude']) ?? _parseDouble(item['latitude']) ?? _parseDouble(item['Lat']);
    final lng = _parseDouble(item['Longitude']) ?? _parseDouble(item['longitude']) ?? _parseDouble(item['Lng']);
    if (lat != null && lng != null) {
      return LatLng(lat, lng);
    }
    return null;
  }
  
  void GetLeadListData() async {
    try {
      String apiUrl =
          '${ApiConfig.baseUrl}$Terant/user/RealestateunqualifiedLeadlist/?id=${User_Id}';

      print("Realestate gigs $apiUrl");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
      };

      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          ListLead = List<Map<String, dynamic>>.from(responseData['results']);
          isLoading = false;
        });
        _fitAllMarkers();
      } else {
        print('API call failed with status code: ${jsonDecode(response.body)}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getSharedPreferencesValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      User_Id = prefs.getInt('User_Id') ?? 0;
      Organization_Id = prefs.getInt('Organization_Id') ?? 0;
      Terant = prefs.getString('Terant') ?? "";
      Roll_Name = prefs.getString('Roll_Name') ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferencesValues().then((_) async {
      GetLeadListData();
    });
  }

  void _fitAllMarkers() {
    if (ListLead.isEmpty || _mapController == null) return;
    double minLat = 90.0, maxLat = -90.0, minLng = 180.0, maxLng = -180.0;
    bool hasValidCoords = false;
    
    for (var item in ListLead) {
      final latLng = _getLatLng(item);
      if (latLng != null) {
        hasValidCoords = true;
        if (latLng.latitude < minLat) minLat = latLng.latitude;
        if (latLng.latitude > maxLat) maxLat = latLng.latitude;
        if (latLng.longitude < minLng) minLng = latLng.longitude;
        if (latLng.longitude > maxLng) maxLng = latLng.longitude;
      }
    }
    
    if (hasValidCoords) {
      // Add a slight delay to ensure map is fully rendered before zooming
      Future.delayed(const Duration(milliseconds: 300), () {
        _mapController?.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          50.0,
        ));
      });
    }
  }

  void _animateTo(LatLng latLng) {
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: latLng, zoom: 16.0),
    ));
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};
    for (var item in ListLead) {
      final latLng = _getLatLng(item);
      if (latLng != null) {
        String name = item['LeadFirstName']?.toString() ?? 'Unknown Customer';
        String customerId = item['id'].toString();
        
        bool isSelected = _selectedDropdownValue == customerId;

        markers.add(Marker(
          markerId: MarkerId(customerId),
          position: latLng,
          infoWindow: InfoWindow(title: name),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isSelected ? BitmapDescriptor.hueOrange : BitmapDescriptor.hueCyan,
          ),
          onTap: () {
            setState(() {
              _selectedDropdownValue = customerId;
              _selectedCustomerData = item;
            });
            _animateTo(latLng);
            _mapController?.showMarkerInfoWindow(MarkerId(customerId));
          },
        ));
      }
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                ],
              ),
            ),
            child: Center(
              child: Text(
                "Track Customer",
                style: Stylecustomer.HeaderTittleText,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Dropdown Container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Choose a Customer",
                          style: Stylecustomer.Textstyle14black,
                        ),
                        Text(
                          "*",
                          style: TextStyle(
                            fontFamily: GoogleFonts.notoSans().fontFamily,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 186, 4, 4),
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDropdownValue,
                          isExpanded: true,
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                          ),
                          padding: const EdgeInsets.only(left: 16),
                          items: [
                            const DropdownMenuItem(
                              value: 'All',
                              child: Text('All Customers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            ),
                            ...ListLead.map((lead) {
                              String name = lead['LeadFirstName']?.toString() ?? 'Unknown';
                              String customerId = lead['id'].toString();
                              return DropdownMenuItem(
                                value: customerId,
                                child: Text(name, style: const TextStyle(fontSize: 15)),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _selectedDropdownValue = value;
                              if (value == 'All') {
                                _selectedCustomerData = null;
                                _fitAllMarkers();
                              } else {
                                final selected = ListLead.firstWhere((element) => element['id'].toString() == value);
                                _selectedCustomerData = selected;
                                final latLng = _getLatLng(selected);
                                if (latLng != null) {
                                  _animateTo(latLng);
                                  _mapController?.showMarkerInfoWindow(MarkerId(value));
                                }
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Map & Overlays
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey.shade200))
                      ),
                      child: GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(20.5937, 78.9629),
                          zoom: 5.0,
                        ),
                        zoomControlsEnabled: false,
                        myLocationEnabled: true,
                        mapToolbarEnabled: false,
                        markers: _buildMarkers(),
                        onMapCreated: (controller) {
                          _mapController = controller;
                          _mapController?.setMapStyle(_mapStyle);
                          if (!isLoading && ListLead.isNotEmpty) {
                            _fitAllMarkers();
                          }
                        },
                        onTap: (_) {
                          setState(() {
                            // Close popup on map tap if desired, or just do nothing
                            // _selectedCustomerData = null;
                            // _selectedDropdownValue = 'All';
                          });
                        },
                      ),
                    ),
                    if (isLoading)
                      Container(
                        color: Colors.white.withOpacity(0.6),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    // Customer Overview Card Animated Overlay
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      bottom: _selectedCustomerData != null ? 24 : -250,
                      left: 16,
                      right: 16,
                      child: _buildCustomerCard(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerCard() {
    if (_selectedCustomerData == null) return const SizedBox.shrink();
    
    final name = _selectedCustomerData!['LeadFirstName']?.toString() ?? 'Unknown Customer';
    final mobile = _selectedCustomerData!['MobileNo']?.toString() ?? _selectedCustomerData!['MobileNumber']?.toString() ?? 'N/A';
    final email = _selectedCustomerData!['Email']?.toString() ?? _selectedCustomerData!['EmailID']?.toString() ?? 'N/A';
    final company = _selectedCustomerData!['CompanyName']?.toString() ?? '';
    final address = _selectedCustomerData!['AddressLine']?.toString() ?? _selectedCustomerData!['Address']?.toString() ?? 'No address provided';
    final customerType = _selectedCustomerData!['CustomerType']?.toString() ?? '';

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (company.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            company,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      if (customerType.isNotEmpty && company.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            customerType,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54, size: 20),
                    onPressed: () {
                      setState(() {
                        _selectedCustomerData = null;
                        _selectedDropdownValue = 'All';
                        _fitAllMarkers();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.phone_rounded, mobile),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.email_rounded, email),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_on_rounded, address, maxLines: 2),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: Colors.teal.shade500),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14.5, 
              color: Colors.black87,
              height: 1.3
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
