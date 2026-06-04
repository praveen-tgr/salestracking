import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salespersontracking/Models/attendance_model.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';

class CheckInOutOverview extends StatelessWidget {
  final AttendanceRecord record;
  const CheckInOutOverview({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildDailySummary(),
                _buildTimelineSection(),
                _buildAppointmentsSection(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Stylecustomer.CrmColor,
      leading: IconButton(
        icon: const Icon(CupertinoIcons.back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Stylecustomer.CrmColor, Color(0xFF0097A7)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                record.employeeName,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.calendar, size: 16, color: Colors.white70),
                  const SizedBox(width: 8),
                  Text(
                    record.date,
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailySummary() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildSummaryCard("Working Hours", "${record.workingHours} hrs", CupertinoIcons.time, Colors.blue),
          const SizedBox(width: 16),
          _buildSummaryCard("Distance", "${record.totalDistance} km", Icons.directions_walk, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600)),
            Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Logins & Locations"),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _buildTimelineItem(
                  "Check-in",
                  record.checkinTime.split('+')[0],
                  record.checkinPlace,
                  Colors.green,
                  isFirst: true,
                ),
                Container(
                  height: 30,
                  margin: const EdgeInsets.only(left: 11),
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.grey[200]!, width: 2, style: BorderStyle.solid)),
                  ),
                ),
                _buildTimelineItem(
                  "Check-out",
                  record.checkoutTime?.split('+')[0] ?? "--:--",
                  record.checkoutPlace.isEmpty ? "Still Active" : record.checkoutPlace,
                  record.checkoutFlag ? Colors.red : Colors.orange,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String label, String time, String place, Color color, {bool isFirst = false, bool isLast = false}) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(child: Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle))),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$label at $time",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            Text(
              place,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppointmentsSection() {
    if (record.appointments.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Daily Appointments (${record.appointments.length})"),
          ...record.appointments.map((app) => _buildAppointmentCard(app)),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentActivity appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  appointment.appointmentName,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: Stylecustomer.CrmColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (appointment.status == "Process" || appointment.status == "Progress") ? Colors.blue.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appointment.status.toUpperCase(),
                  style: TextStyle(
                    color: (appointment.status == "Process" || appointment.status == "Progress") ? Colors.blue : Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(appointment.location, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAppointmentTime("Start", appointment.startTime),
              _buildAppointmentTime("End", appointment.endTime),
              _buildAppointmentTime("Spent", "${appointment.hoursSpent}h"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentTime(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400], fontWeight: FontWeight.w600)),
        Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey[400], letterSpacing: 1.5),
      ),
    );
  }
}
