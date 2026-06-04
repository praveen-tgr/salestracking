import 'dart:convert';

class AttendanceResponse {
  final int count;
  final List<AttendanceRecord> results;

  AttendanceResponse({required this.count, required this.results});

  factory AttendanceResponse.fromMap(Map<String, dynamic> map) {
    return AttendanceResponse(
      count: map['count'] ?? 0,
      results: List<AttendanceRecord>.from(
        (map['results'] ?? []).map((x) => AttendanceRecord.fromMap(x)),
      ),
    );
  }
}

class AttendanceRecord {
  final int id;
  final String employeeName;
  final String date;
  final String checkinDate;
  final String? checkoutDate;
  final String checkinTime;
  final String? checkoutTime;
  final String location;
  final String totalDistance;
  final int totalAppointments;
  final String checkinPlace;
  final String checkoutPlace;
  final double workingHours;
  final bool checkinFlag;
  final bool checkoutFlag;
  final List<AppointmentActivity> appointments;

  AttendanceRecord({
    required this.id,
    required this.employeeName,
    required this.date,
    required this.checkinDate,
    this.checkoutDate,
    required this.checkinTime,
    this.checkoutTime,
    required this.location,
    required this.totalDistance,
    required this.totalAppointments,
    required this.checkinPlace,
    required this.checkoutPlace,
    required this.workingHours,
    required this.checkinFlag,
    required this.checkoutFlag,
    required this.appointments,
  });

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id'] ?? 0,
      employeeName: map['Employee_name'] ?? '',
      date: map['Date'] ?? '',
      checkinDate: map['Checkin_Date'] ?? '',
      checkoutDate: map['Checkout_Date'],
      checkinTime: map['Checkin_Time'] ?? '',
      checkoutTime: map['Checkout_Time'],
      location: map['Location'] ?? '',
      totalDistance: map['Total_distance'] ?? '0',
      totalAppointments: map['Total_apointmnets'] ?? 0,
      checkinPlace: map['Checkin_Place'] ?? '',
      checkoutPlace: map['Checkout_Place'] ?? '',
      workingHours: (map['Working_Hours'] ?? 0.0).toDouble(),
      checkinFlag: map['Checkin_Flag'] ?? false,
      checkoutFlag: map['Checkout_Flag'] ?? false,
      appointments: List<AppointmentActivity>.from(
        (map['AppoinmentCheckInCheckOut_Id'] ?? []).map((x) => AppointmentActivity.fromMap(x)),
      ),
    );
  }
}

class AppointmentActivity {
  final int id;
  final String appointmentName;
  final String date;
  final String location;
  final String startTime;
  final String endTime;
  final double hoursSpent;
  final String status;
  final String? description;

  AppointmentActivity({
    required this.id,
    required this.appointmentName,
    required this.date,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.hoursSpent,
    required this.status,
    this.description,
  });

  factory AppointmentActivity.fromMap(Map<String, dynamic> map) {
    return AppointmentActivity(
      id: map['id'] ?? 0,
      appointmentName: map['Appointment_Name'] ?? '',
      date: map['Date'] ?? '',
      location: map['Location'] ?? '',
      startTime: map['Start_Time'] ?? '',
      endTime: map['End_Time'] ?? '',
      hoursSpent: (map['Hours_Spent'] ?? 0.0).toDouble(),
      status: map['Status'] ?? '',
      description: map['Description'],
    );
  }
}
