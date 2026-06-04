import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salespersontracking/Models/attendance_model.dart';
import 'package:salespersontracking/Providers/Home/home_provider.dart';
import 'package:salespersontracking/Providers/dio_provider.dart';

part 'attendance_provider.g.dart';

@riverpod
class AttendanceNotifier extends _$AttendanceNotifier {
  @override
  FutureOr<List<AttendanceRecord>> build() async {
    // Default to last 30 days
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 30));
    return fetchAttendance(
      DateFormat('yyyy-MM-dd').format(startDate),
      DateFormat('yyyy-MM-dd').format(now),
    );
  }

  Future<List<AttendanceRecord>> fetchAttendance(String startDate, String endDate) async {
    final dio = ref.watch(dioProvider);
    final userData = await ref.read(userDataProvider.future);
    final String terant = userData['Terant'] as String? ?? "";

    try {
      final String apiUrl = '$terant/user/WelcomeCheckInListsent/';
      final Map<String, dynamic> payload = {
        "period": [startDate, endDate]
      };

      final response = await dio.post(apiUrl, data: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final attendanceResponse = AttendanceResponse.fromMap(response.data);
        if (attendanceResponse.results.isNotEmpty) {
          return attendanceResponse.results;
        }
      }
      return [_getDummyRecord(startDate)];
    } catch (e) {
      print('Attendance Fetch Error: $e');
      return [_getDummyRecord(startDate)];
    }
  }

  AttendanceRecord _getDummyRecord(String date) {
    return AttendanceRecord(
      id: -1,
      employeeName: "Sample User (Demo)",
      date: date,
      checkinDate: date,
      checkinTime: "09:00:00",
      checkoutTime: "18:00:00",
      location: "Sample Office Building, Innovation Park",
      totalDistance: "12.5",
      totalAppointments: 2,
      checkinPlace: "Main Entrance",
      checkoutPlace: "East Exit",
      workingHours: 9.0,
      checkinFlag: true,
      checkoutFlag: true,
      appointments: [
        AppointmentActivity(
          id: -1,
          appointmentName: "Project Kickoff Meeting",
          date: date,
          location: "Conference Room B",
          startTime: "10:30:00",
          endTime: "11:30:00",
          hoursSpent: 1.0,
          status: "Completed",
          description: "Initial discussion regarding the new project milestones and deliverables.",
        ),
        AppointmentActivity(
          id: -2,
          appointmentName: "Technical Review",
          date: date,
          location: "Virtual Meeting",
          startTime: "14:00:00",
          endTime: "15:00:00",
          hoursSpent: 1.0,
          status: "Completed",
          description: "Reviewing the technical architecture and security protocols.",
        )
      ],
    );
  }

  Future<void> refreshAttendance() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 30));
      return fetchAttendance(
        DateFormat('yyyy-MM-dd').format(startDate),
        DateFormat('yyyy-MM-dd').format(now),
      );
    });
  }
}
