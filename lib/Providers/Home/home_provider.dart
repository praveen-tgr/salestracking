import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salespersontracking/Providers/dio_provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_provider.g.dart';

@riverpod
class HomeData extends _$HomeData {
  @override
  FutureOr<void> build() async {
    return;
  }

  Future<Map<String, dynamic>> fetchCurrentCheckIn(
    int userId,
    String terant,
  ) async {
    final dio = ref.read(dioProvider);
    final presentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String apiUrl =
        '$terant/user/Mastercheckinoutsalespersonlist/?Salesperson_id=$userId&enddate=$presentDate&startdate=$presentDate';

    final response = await dio.get(apiUrl);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to fetch check-in data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAppointments(
    int userId,
    String terant,
    String date,
  ) async {
    final dio = ref.read(dioProvider);
    final String apiUrl =
        '$terant/user/UserLeadMeetingmylList/?Created_By=$userId&fromdate=$date&todate=$date';

    final response = await dio.get(apiUrl);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return List<Map<String, dynamic>>.from(response.data['results']);
    } else {
      throw Exception('Failed to fetch appointment list');
    }
  }

  Future<void> checkIn(Map<String, dynamic> payload, String terant) async {
    state = const AsyncValue.loading();
    try {
      final dio = ref.read(dioProvider);
      final String apiUrl = '$terant/user/EmployeecheckinCRUD/';

      final response = await dio.post(apiUrl, data: payload);
      if (response.statusCode == 200 || response.statusCode == 201) {
        state = const AsyncValue.data(null);
        // Refresh check-in data would happen in UI or via another provider refetch
      } else {
        throw Exception('Check-in failed');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> checkOut(Map<String, dynamic> payload, String terant) async {
    state = const AsyncValue.loading();
    try {
      final dio = ref.read(dioProvider);
      final String apiUrl = '$terant/user/EmployeecheckinCRUD/';

      final response = await dio.patch(apiUrl, data: payload);
      if (response.statusCode == 200 || response.statusCode == 201) {
        state = const AsyncValue.data(null);
      } else {
        throw Exception('Check-out failed');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
Future<Map<String, dynamic>> currentCheckIn(
  Ref ref, {
  required int userId,
  required String terant,
}) async {
  final dio = ref.watch(dioProvider);
  final presentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final String apiUrl =
      '$terant/user/Mastercheckinoutsalespersonlist/?Salesperson_id=$userId&enddate=$presentDate&startdate=$presentDate';

  final response = await dio.get(apiUrl);
  return response.data;
}

@riverpod
Future<List<Map<String, dynamic>>> appointmentList(
  Ref ref, {
  required int userId,
  required String terant,
  required String date,
}) async {
  final dio = ref.watch(dioProvider);
  final String apiUrl =
      '$terant/user/UserLeadMeetingmylList/?Created_By=$userId&fromdate=$date&todate=$date';
  final response = await dio.get(apiUrl);
  return List<Map<String, dynamic>>.from(response.data['results']);
}

@riverpod
class UserData extends _$UserData {
  @override
  FutureOr<Map<String, dynamic>> build() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'User_Id': prefs.getInt('User_Id') ?? 0,
      'Organization_Id': prefs.getInt('Organization_Id') ?? 0,
      'Terant': prefs.getString('Terant') ?? "",
      'username': prefs.getString('username') ?? "",
      'Token': prefs.getString('Token') ?? "",
      'Designation': prefs.getString('Designation') ?? "",
    };
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    ref.invalidateSelf();
  }
}
