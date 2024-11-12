import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationRepository {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  Future<void> login(String username, String password) async {
    try {
      print("login_try");
      Response response = await _dio.post(
        'http://hitto.synology.me:9000/login',
        data: {
          'username': username,
          'password': password,
        },
      );
      String accessToken = response.data['accessToken'];
      String refreshToken = response.data['refreshToken'];
      print("accessToken: ${accessToken}");
      print("refreshToken: ${refreshToken}");

      await _storage.write(key: 'accessToken', value: accessToken);
      await _storage.write(key: 'refreshToken', value: refreshToken);
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}