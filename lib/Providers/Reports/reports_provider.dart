import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salespersontracking/Models/report_model.dart';
import 'package:salespersontracking/Providers/Home/home_provider.dart';
import 'package:salespersontracking/Providers/dio_provider.dart';

part 'reports_provider.g.dart';

@riverpod
class DailyActivity extends _$DailyActivity {
  @override
  FutureOr<List<ActivityRecord>> build(String date) async {
    final dio = ref.watch(dioProvider);
    final userData = await ref.watch(userDataProvider.future);
    final String terant = userData['Terant'] as String? ?? "";
    final int userId = userData['User_Id'] as int? ?? 0;

    try {
      final String apiUrl = '$terant/user/commonactivityslist/';
      final payload = {
        "Created_Date": date,
        "Created_By": userId
      };

      final response = await dio.post(apiUrl, data: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> list = response.data['Useractivity'] ?? [];
        return list.map((x) => ActivityRecord.fromMap(x)).toList();
      }
      return [];
    } catch (e) {
      print('DailyActivity Fetch Error: $e');
      return [];
    }
  }
}

@riverpod
class SalesDashboard extends _$SalesDashboard {
  @override
  FutureOr<SalesDashboardMetric> build({required String fromDate, required String toDate, int? userId}) async {
    final dio = ref.watch(dioProvider);
    final userData = await ref.watch(userDataProvider.future);
    final String terant = userData['Terant'] as String? ?? "";
    
    try {
      final String apiUrl = '$terant/user/AnalysticSalesDashboard/';
      final payload = {
        "Is_Deleted": false,
        "fromdate": fromDate,
        "todate": toDate,
        "userid": userId ?? "all"
      };

      final response = await dio.post(apiUrl, data: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SalesDashboardMetric.fromMap(response.data);
      }
      throw Exception('Failed to load sales dashboard');
    } catch (e) {
      print('SalesDashboard Fetch Error: $e');
      rethrow;
    }
  }
}
