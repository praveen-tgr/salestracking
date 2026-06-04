import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';

class AppointmentOverview extends StatelessWidget {
  final Map<String, dynamic> appointmentData;

  const AppointmentOverview({super.key, required this.appointmentData});

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
              child: Text(
                "Appointment Details",
                style: Stylecustomer.HeaderTittleText,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 20),
            _buildDetailsCard(),
            const SizedBox(height: 20),
            _buildDescriptionCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final status = appointmentData['Status'] ?? 'Pending';
    final isCompleted = status == "Completed";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Stylecustomer.CrmColor.withOpacity(0.1),
            child: const Icon(Icons.business, size: 30, color: Stylecustomer.CrmColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointmentData['Venue']?.toString() ?? 'Unknown Venue',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  appointmentData['Location']?.toString() ?? 'No Location',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    String formattedDate = "N/A";
    String formattedFromTime = "N/A";
    String formattedToTime = "N/A";

    try {
      if (appointmentData["Date"] != null) {
        formattedDate = DateFormat("MMM dd, yyyy").format(DateFormat("yyyy-MM-dd").parse(appointmentData["Date"]));
      }
      if (appointmentData["FromDate_Time"] != null) {
        formattedFromTime = DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(appointmentData["FromDate_Time"]));
      }
      if (appointmentData["ToDate_Time"] != null) {
        formattedToTime = DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(appointmentData["ToDate_Time"]));
      }
    } catch (_) {}

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.calendar_today, "Date", formattedDate),
          const Divider(height: 24),
          _buildInfoRow(Icons.access_time, "Time Window", "$formattedFromTime  -  $formattedToTime"),
          const Divider(height: 24),
          _buildInfoRow(Icons.category, "Meeting Type", appointmentData['Meeting_Type']?.toString() ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            appointmentData['Details']?.toString() ?? appointmentData['Subject']?.toString() ?? 'No description provided.',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800], height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Stylecustomer.CrmColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Stylecustomer.CrmColor, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500])),
            const SizedBox(height: 4),
            Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
