// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_unnecessary_containers, sized_box_for_whitespace, file_names

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:salespersontracking/Pages/Home/Appointment/AppointmentList.dart';
import 'package:salespersontracking/ApiConfig/ApiConfig.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:salespersontracking/Style/TextFieldStyle.dart';
import 'package:salespersontracking/Validation/ToastMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAppointment extends StatefulWidget {
  final Map<String, dynamic> appointmentData;

  const EditAppointment({super.key, required this.appointmentData});

  @override
  State<EditAppointment> createState() => _EditAppointmentState();
}

class _EditAppointmentState extends State<EditAppointment> {
  int? User_Id;
  int? Organization_Id;
  String? Terant;
  String? username;

  List<Map<String, dynamic>> CustomerData = [];
  bool isLoading = true;
  bool isSaving = false;

  final _formKey = GlobalKey<FormState>();

  String? selectedCustomerName;
  String? selectedMeetingType;
  
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  DateTime? selectedDate;
  TimeOfDay? selectedFromTime;
  TimeOfDay? selectedToTime;

  final List<String> meetingTypes = [
    "Sales",
    "Installation",
    "Service",
    "Fault Service"
  ];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User_Id = prefs.getInt('User_Id') ?? 0;
    Organization_Id = prefs.getInt('Organization_Id') ?? 0;
    Terant = prefs.getString('Terant') ?? "";
    username = prefs.getString('username') ?? "";

    await _fetchCustomers();
    _prefillData();
  }

  void _prefillData() {
    final data = widget.appointmentData;
    
    // Attempting to match Customer Name by returning the previously saved Lead_Id or matching it
    // Usually UserLeadMeetingCRUD data contains Lead_name or Lead_Id
    try {
       int leadId = data['Lead_Id'] ?? 0;
       if (leadId != 0) {
         final cust = CustomerData.firstWhere((e) => e['id'] == leadId, orElse: () => {});
         if (cust.isNotEmpty) {
           selectedCustomerName = cust['CompanyName'];
         }
       }
    } catch (_) {}

    selectedMeetingType = data['Meeting_Type'];
    _locationController.text = data['Location'] ?? '';
    _venueController.text = data['Venue'] ?? '';
    _descriptionController.text = data['Details'] ?? data['Subject'] ?? '';

    try {
      if (data["Date"] != null) {
        selectedDate = DateFormat("yyyy-MM-dd").parse(data["Date"]);
      }
      if (data["FromDate_Time"] != null) {
        final dt = DateFormat("HH:mm:ss").parse(data["FromDate_Time"]);
        selectedFromTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
      }
      if (data["ToDate_Time"] != null) {
        final dt = DateFormat("HH:mm:ss").parse(data["ToDate_Time"]);
        selectedToTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
      }
    } catch (_) {}
  }

  Future<void> _fetchCustomers() async {
    try {
      String apiUrl = '${ApiConfig.baseUrl}$Terant/user/UserQualifiedListAdditional/';
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          CustomerData = List<Map<String, dynamic>>.from(responseData);
        });
      }
    } catch (e) {
      debugPrint("Error fetching customers: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCustomerName == null || selectedMeetingType == null || selectedDate == null || selectedFromTime == null || selectedToTime == null) {
      ErrorToast.showToast(context: context, title: 'Error', description: 'Please fill all required fields');
      return;
    }

    setState(() => isSaving = true);

    try {
      String apiUrl = "${ApiConfig.baseUrl}$Terant/user/UserLeadMeetingCRUD/?id=${widget.appointmentData['id'] ?? widget.appointmentData['Id']}";
      
      final matCustomer = CustomerData.firstWhere(
        (e) => e['CompanyName'] == selectedCustomerName,
        orElse: () => {},
      );
      int cId = matCustomer['id'] ?? widget.appointmentData['Lead_Id'] ?? 0;

      final formattedDate = DateFormat("yyyy-MM-dd").format(selectedDate!);
      
      final fromDt = DateTime(2000, 1, 1, selectedFromTime!.hour, selectedFromTime!.minute);
      final toDt = DateTime(2000, 1, 1, selectedToTime!.hour, selectedToTime!.minute);
      final fromTimeStr = DateFormat('HH:mm').format(fromDt);
      final toTimeStr = DateFormat('HH:mm').format(toDt);

      Map<String, dynamic> payload = {
        "Meeting_Type": selectedMeetingType,
        "FromDate_Time": fromTimeStr,
        "ToDate_Time": toTimeStr,
        "Date": formattedDate,
        "Subject": _descriptionController.text,
        "Details": _descriptionController.text,
        "Location": _locationController.text,
        "Venue": _venueController.text,
        "Status": widget.appointmentData['Status'] ?? "Pending",
        "Organization_Id": Organization_Id,
        "Lead_Id": cId,
        "Updated_By": User_Id,
      };

      var response = await http.put(
        Uri.parse(apiUrl),
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        SuccessToast.showToast(context: context, title: 'Success', description: 'Appointment Updated Successfully');
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AppointmentList(Navigation: 0, TabIndex: 0)));
      } else {
        ErrorToast.showToast(context: context, title: 'Error', description: 'Failed to update appointment');
      }
    } catch (e) {
      ErrorToast.showToast(context: context, title: 'Error', description: 'Network issue occurred.');
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> _pickTime(bool isFrom) async {
    final time = await showTimePicker(
      context: context,
      initialTime: isFrom ? (selectedFromTime ?? TimeOfDay.now()) : (selectedToTime ?? TimeOfDay.now()),
    );
    if (time != null) {
      setState(() {
        if (isFrom) selectedFromTime = time;
        else selectedToTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.arrow_left, color: Colors.black, size: 25),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: MediaQuery.of(context).size.height * 0.09,
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
              child: Text("Edit Appointment", style: Stylecustomer.HeaderTittleText),
            ),
          ),
        ),
        actions: [
          IconButton(
             icon: isSaving 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                : const Icon(Icons.check, color: Colors.black, size: 28),
             onPressed: isSaving ? null : _handleUpdate,
          )
        ],
      ),
      body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildSectionTitle("General Info"),
                  _buildDropdownField(
                    label: "Customer*",
                    value: CustomerData.map((e) => e['CompanyName'].toString()).contains(selectedCustomerName) ? selectedCustomerName : null,
                    items: CustomerData.map((e) => e['CompanyName'].toString()).where((e) => e.isNotEmpty && e != 'null').toList(),
                    onChanged: (v) => setState(() => selectedCustomerName = v),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: "Meeting Type*",
                    value: selectedMeetingType,
                    items: meetingTypes,
                    onChanged: (v) => setState(() => selectedMeetingType = v),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(label: "Location*", controller: _locationController, hint: "Enter location"),
                  const SizedBox(height: 16),
                  _buildTextField(label: "Venue*", controller: _venueController, hint: "Enter venue name"),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle("Schedule"),
                  
                  GestureDetector(
                    onTap: _pickDate,
                    child: _buildSelectorBox(
                      label: "Date*",
                      value: selectedDate != null ? DateFormat('MMM dd, yyyy').format(selectedDate!) : "Select Date",
                      icon: Icons.calendar_today,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickTime(true),
                          child: _buildSelectorBox(
                            label: "From Time*",
                            value: selectedFromTime?.format(context) ?? "--:--",
                            icon: Icons.access_time,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                         child: GestureDetector(
                          onTap: () => _pickTime(false),
                          child: _buildSelectorBox(
                            label: "To Time*",
                            value: selectedToTime?.format(context) ?? "--:--",
                            icon: Icons.access_time,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle("Details"),
                  _buildTextField(
                    label: "Description*", 
                    controller: _descriptionController, 
                    hint: "Agenda of the meeting", 
                    maxLines: 4
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          )
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey[700])),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, required String hint, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: (v) => v == null || v.trim().isEmpty ? "Required Field" : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Stylecustomer.CrmColor, width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label, required String? value, required List<String> items, required void Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Stylecustomer.CrmColor, width: 1.5)),
          ),
          items: items.toSet().toList().map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.poppins(fontSize: 14)))).toList(),
          onChanged: onChanged,
          validator: (v) => v == null ? "Required Field" : null,
        )
      ],
    );
  }

  Widget _buildSelectorBox({required String label, required String value, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: GoogleFonts.poppins(fontSize: 14, color: value.contains("Select") || value.contains("--") ? Colors.grey[500] : Colors.black87)),
              Icon(icon, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
