// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:salespersontracking/ApiConfig/ApiConfig.dart';
import 'package:salespersontracking/Pages/Home/Appointment/AppointmentCreate.dart';
import 'package:salespersontracking/Pages/Home/Appointment/AppointmentEdit.dart';
import 'package:salespersontracking/Pages/Home/Appointment/AppointmentOverview.dart';
import 'package:salespersontracking/Pages/Home/Home.dart';
import 'package:salespersontracking/Pages/Profile/Profile.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:salespersontracking/Validation/ToastMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentList extends StatefulWidget {
  final int Navigation;
  final int TabIndex;
  const AppointmentList({
    super.key,
    required this.Navigation,
    required this.TabIndex,
  });

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  String Presentdate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool isLoading = true;
  int? User_Id;
  String? Terant;
  
  List<Map<String, dynamic>> ListLead = [];
  
  final List<String> dateFilters = [
    'Today',
    'This Week',
    'This Month',
    'This Year',
    'All',
  ];
  String selectedFilter = 'This Month';

  @override
  void initState() {
    super.initState();
    getSharedPreferencesValues().then((_) {
      GetAppointmentListData();
    });
  }

  Future<void> getSharedPreferencesValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      User_Id = prefs.getInt('User_Id') ?? 0;
      Terant = prefs.getString('Terant') ?? "";
    });
  }

  Map<String, String> getDateRange(String filter) {
    final now = DateTime.now();
    late DateTime fromDate;
    late DateTime toDate;

    switch (filter) {
      case 'Today':
        fromDate = toDate = now;
        break;
      case 'This Week':
        fromDate = now.subtract(Duration(days: now.weekday - 1));
        toDate = fromDate.add(const Duration(days: 6));
        break;
      case 'This Month':
        fromDate = DateTime(now.year, now.month, 1);
        toDate = DateTime(now.year, now.month + 1, 0);
        break;
      case 'This Year':
        fromDate = DateTime(now.year, 1, 1);
        toDate = DateTime(now.year, 12, 31);
        break;
      case 'All':
        fromDate = DateTime(2000, 1, 1);
        toDate = DateTime(2100, 12, 31);
        break;
      default:
        fromDate = toDate = now;
    }

    return {
      'from': DateFormat('yyyy-MM-dd').format(fromDate),
      'to': DateFormat('yyyy-MM-dd').format(toDate),
    };
  }

  void GetAppointmentListData({String? filter}) async {
    final range = getDateRange(filter ?? selectedFilter);

    try {
      String apiUrl = '${ApiConfig.baseUrl}$Terant/user/UserLeadMeetingmylList/?Created_By=$User_Id&fromdate=${range['from']}&todate=${range['to']}';

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
      };

      http.Response response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          ListLead = List<Map<String, dynamic>>.from(responseData['results'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (error) {
      setState(() => isLoading = false);
    }
  }

  Future<void> DeleteLead(data) async {
    try {
      String apiUrl = '${ApiConfig.baseUrl}$Terant/user/RealestateLeadCRUD/?id=${data['id'] ?? data['Id']}';

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
      };

      http.Response response = await http.delete(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() => isLoading = true);
        SuccessToast.showToast(context: context, title: 'Lead', description: 'Appointment Deleted Successfully');
        GetAppointmentListData();
      } else {
        ErrorToast.showToast(context: context, title: 'Error', description: 'Failed to delete');
      }
    } catch (error) {
      ErrorToast.showToast(context: context, title: 'Error', description: 'Network error occurred');
    }
  }

  void showDeleteConfirmation(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Appointment", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to delete this appointment?", style: GoogleFonts.poppins(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              Navigator.pop(context);
              DeleteLead(data);
            },
            child: Text("Delete", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String formatTimeSafely(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return "N/A";
    try {
      final dt = DateFormat("HH:mm:ss").parse(timeStr);
      return DateFormat("hh:mm a").format(dt);
    } catch (_) {
      return timeStr; // Return raw if parsing fails
    }
  }

  Widget _buildAppointmentCard(Map<String, dynamic> item) {
    final status = item['Status'] ?? 'Pending';
    final isCompleted = status == "Completed";
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppointmentOverview(appointmentData: item)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: isCompleted ? Colors.green : Colors.orange),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onSelected: (val) {
                        if (val == 'Edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditAppointment(appointmentData: item)),
                          );
                        } else if (val == 'Delete') {
                          showDeleteConfirmation(item);
                        } else if (val == 'View') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AppointmentOverview(appointmentData: item)),
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'View', child: Text("View Details")),
                        const PopupMenuItem(value: 'Edit', child: Text("Edit Appointment")),
                        const PopupMenuItem(value: 'Delete', child: Text("Delete", style: TextStyle(color: Colors.red))),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item['Subject']?.toString() ?? item['Details']?.toString() ?? 'Meeting',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item['Venue']?.toString() ?? 'Remote / N/A',
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Stylecustomer.CrmColor),
                        const SizedBox(width: 6),
                        Text(
                          item['Date'] != null ? DateFormat('MMM dd').format(DateFormat('yyyy-MM-dd').parse(item['Date'])) : 'N/A',
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                         const Icon(Icons.access_time, size: 14, color: Stylecustomer.CrmColor),
                         const SizedBox(width: 6),
                         Text(
                           "${formatTimeSafely(item['FromDate_Time'])}",
                           style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
                         ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Stylecustomer.CrmColor, statusBarIconBrightness: Brightness.light),
    );

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => widget.Navigation == 1 ? const Profile() : const Home()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFB),
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => widget.Navigation == 1 ? const Profile() : const Home()),
              );
            },
            child: const Icon(CupertinoIcons.arrow_left, color: Colors.black, size: 25),
          ),
          backgroundColor: Colors.white,
          toolbarHeight: MediaQuery.of(context).size.height * 0.08,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.white, Color.fromRGBO(7, 182, 182, 1)],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text("Appointments", style: Stylecustomer.HeaderTittleText),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                icon: const Icon(Icons.add_circle, color: Stylecustomer.CrmColor, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AppointmentCreate()),
                  );
                },
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Filters Row
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                         padding: const EdgeInsets.symmetric(horizontal: 16),
                         child: DropdownButtonHideUnderline(
                           child: DropdownButton<String>(
                             value: selectedFilter,
                             icon: const Icon(Icons.arrow_drop_down, color: Stylecustomer.CrmColor),
                             isExpanded: true,
                             items: dateFilters.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.poppins(fontSize: 14)))).toList(),
                             onChanged: (val) {
                               if (val != null) {
                                  setState(() { selectedFilter = val; isLoading = true; });
                                  GetAppointmentListData(filter: val);
                               }
                             },
                           ),
                         ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // List view
              Expanded(
                child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListLead.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy, size: 80, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text("No Appointments Found", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600])),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => GetAppointmentListData(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          itemCount: ListLead.length,
                          itemBuilder: (context, index) {
                            return _buildAppointmentCard(ListLead[index]);
                          },
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
