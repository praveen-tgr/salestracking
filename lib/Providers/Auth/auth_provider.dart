import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salespersontracking/Providers/Home/home_provider.dart';
import 'package:salespersontracking/Providers/dio_provider.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> login(String username, String password, String terant) async {
    state = const AsyncValue.loading();
    try {
      final dio = ref.read(dioProvider);
      final String apiUrl = '$terant/auth_token';
      
      final response = await dio.post(apiUrl, data: {
        "username": username,
        "password": password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data['token'];
        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('Token', token);
          
          // Fetch user data after login
          await _fetchUserData(username, terant);
          state = const AsyncValue.data(null);
        } else {
          state = AsyncValue.error('Invalid token received', StackTrace.current);
        }
      } else {
        state = AsyncValue.error('Login failed: ${response.data}', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _fetchUserData(String username, String terant) async {
    final dio = ref.read(dioProvider);
    final String apiUrl = '$terant/useradmin/UserCRUD_GET/?username=$username';
    
    final response = await dio.get(apiUrl);
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('LoginBool', true);
      await prefs.setInt('User_Id', data['id']);
      await prefs.setInt('Organization_Id', data['Organization_Id']);
      await prefs.setString('username', data['username']);
      await prefs.setString('fullname', "${data['first_name']} ${data['last_name']}");
      await prefs.setString('email', data['email']);
      await prefs.setString('Designation', data['Designation']);
      await prefs.setString('PhoneNo', data['PhoneNo']);
      await prefs.setString('Roll_Name', data['Roll_Name'] ?? "");
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
}

@riverpod
Future<Map<String, dynamic>> profileDetails(Ref ref) async {
  final userData = await ref.watch(userDataProvider.future);
  final dio = ref.read(dioProvider);
  final String terant = userData['Terant'] as String? ?? "";
  final String username = userData['username'] as String? ?? "";
  
  if (terant.isEmpty || username.isEmpty) {
    throw Exception('User session invalid');
  }

  final String apiUrl = '$terant/useradmin/UserCRUD_GET/?username=$username';
  final response = await dio.get(apiUrl);
  
  if (response.statusCode == 200 || response.statusCode == 201) {
    return response.data;
  } else {
    throw Exception('Failed to fetch profile details');
  }
}
