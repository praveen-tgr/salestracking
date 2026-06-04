import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salespersontracking/Models/attendance_model.dart';
import 'package:salespersontracking/Pages/Checkin-outList.dart/CheckInOutOverview.dart';
import 'package:salespersontracking/Providers/Attendance/attendance_provider.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';

class CheckInList extends ConsumerStatefulWidget {
  const CheckInList({super.key});

  @override
  ConsumerState<CheckInList> createState() => _CheckInListState();
}

class _CheckInListState extends ConsumerState<CheckInList> {
  @override
  Widget build(BuildContext context) {
    final attendanceAsync = ref.watch(attendanceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          "Work Timeline",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Stylecustomer.CrmColor,
                Colors.white,
              ],
              stops: [0.0, 0.4],
            ),
          ),
        ),
      ),
      body: attendanceAsync.when(
        data: (records) {
          if (records.isEmpty) {
            return _buildEmptyState();
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(attendanceProvider.notifier).refreshAttendance(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return _buildAttendanceCard(record);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Stylecustomer.CrmColor)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildAttendanceCard(AttendanceRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CheckInOutOverview(record: record)),
        ),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Top row: Date and Working Hours
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(CupertinoIcons.calendar, size: 18, color: Stylecustomer.CrmColor),
                      const SizedBox(width: 8),
                      Text(
                        record.date,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Stylecustomer.CrmColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "${record.workingHours} hrs",
                      style: GoogleFonts.poppins(
                        color: Stylecustomer.CrmColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1),
              ),
              // Timeline Row
              Row(
                children: [
                  _buildTimelinePoint(
                    "Check-in",
                    record.checkinTime.split('+')[0],
                    record.checkinPlace,
                    CupertinoIcons.arrow_right_circle_fill,
                    Colors.green,
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.grey[200],
                    ),
                  ),
                  _buildTimelinePoint(
                    "Check-out",
                    record.checkoutTime?.split('+')[0] ?? "--:--",
                    record.checkoutPlace.isEmpty ? "In Progress" : record.checkoutPlace,
                    CupertinoIcons.arrow_left_circle_fill,
                    record.checkoutFlag ? Colors.red : Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Footer: Distance
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.directions_walk, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      "Distance Traveled:",
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Text(
                      "${record.totalDistance} km",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelinePoint(String label, String time, String place, IconData icon, Color color) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: label == "Check-in" ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label == "Check-in") Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400], fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              if (label == "Check-out") Icon(icon, size: 14, color: color),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87),
          ),
          Text(
            place,
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: label == "Check-in" ? TextAlign.left : TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.clock, size: 80, color: Colors.grey[200]),
          const SizedBox(height: 16),
          Text(
            "No activity records found",
            style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
