import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salespersontracking/Models/customer_model.dart';
import 'package:salespersontracking/Providers/Home/home_provider.dart';
import 'package:salespersontracking/Providers/dio_provider.dart';

part 'customer_provider.g.dart';

@riverpod
class CustomerNotifier extends _$CustomerNotifier {
  @override
  FutureOr<List<Customer>> build() async {
    return _fetchCustomers();
  }

  Future<List<Customer>> _fetchCustomers() async {
    final dio = ref.watch(dioProvider);
    final userData = await ref.watch(userDataProvider.future);
    final String terant = userData['Terant'] as String? ?? "";
    final int userId = userData['User_Id'] as int? ?? 0;

    try {
      // Assuming lead list as the base for customers if specific CRUD isn't found
      // or using a generic Customer CRUD endpoint
      final String apiUrl = '$terant/user/CustomerCRUD/?id=$userId';
      final response = await dio.get(apiUrl);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['results'] ?? []);
        return data.map((e) => Customer.fromMap(e)).toList();
      }
      return [];
    } catch (e) {
      // Fallback to Lead List pattern found in Tracking.dart if CustomerCRUD fails
      try {
        final String fallbackUrl =
            '$terant/user/RealestateunqualifiedLeadlist/?id=$userId';
        final response = await dio.get(fallbackUrl);
        if (response.statusCode == 200) {
          final List<dynamic> data = response.data['results'] ?? [];
          return data.map((e) => Customer.fromMap(e)).toList();
        }
      } catch (_) {}
      return [];
    }
  }

  Future<void> addCustomer(Customer customer) async {
    state = const AsyncValue.loading();
    final dio = ref.read(dioProvider);
    final userData = await ref.read(userDataProvider.future);
    final String terant = userData['Terant'] as String? ?? "";

    try {
      final String apiUrl = '$terant/user/CustomerCRUD/';
      await dio.post(apiUrl, data: customer.toMap());
      ref.invalidateSelf();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    state = const AsyncValue.loading();
    final dio = ref.read(dioProvider);
    final userData = await ref.read(userDataProvider.future);
    final String terant = userData['Terant'] as String? ?? "";

    try {
      final String apiUrl = '$terant/user/CustomerCRUD/';
      await dio.put(apiUrl, data: customer.toMap());
      ref.invalidateSelf();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

@riverpod
FutureOr<List<String>> customerLookups(Ref ref, String category) async {
  final dio = ref.watch(dioProvider);
  try {
    final response = await dio.get('useradmin/Userlookuplist/');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      final categoryData = data.firstWhere(
        (item) => item["Lookupname"] == category,
        orElse: () => null,
      );
      if (categoryData != null) {
        return (categoryData["Values"] as List)
            .map<String>((e) => e["value"] as String)
            .toList();
      }
    }
  } catch (_) {}
  return [];
}
