import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_frontend/features/auth/models/user_profile_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

  @riverpod
  AuthService authService(Ref ref) => AuthService();

class AuthService{

  // Using 10.0.2.2 for Android emulator to access fastapi on localhost

  final _dio = Dio(BaseOptions(

    // for chrome 
    // baseUrl: 'http://localhost:8000',

    // For emulators
    // baseUrl: 'http://10.0.2.2:8000',

    baseUrl: kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000',
    
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));



  // To store jwt token securely
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      resetOnError: true,
    )
  );

  Future<void> saveToken(String token) async => 
    await _storage.write(key: 'jwt_token', value: token);

  Future<String?> getToken() async =>
    await _storage.read(key: 'jwt_token');

  Future<void> logout() async =>
    await _storage.delete(key: 'jwt_token');

  // Backend POST Request for SignUp a User : Creating a User
  Future<Response> signup(String email , String password) async {
    return await _dio.post('/signup' , data: {
      'email' : email,
      'password' : password,
    });
  }
  
  Future<Response> login(String email , String password) async {
    try{
      return await _dio.post('/login' , data: {
      'email' : email,
      'password' : password,
    });
    } on DioException catch (e) {
      throw e.response?.statusCode.toString() ?? "Connection Error";
    }
  }
  
  Future<Response> updateProfile({
      required String name,
      DateTime? birthdate,
    }) async {
      final token = await getToken();

      // create data map
      final Map<String,dynamic> data = {
        'full_name' : name,
      };

      // Add birthdate when provided
      if (birthdate != null){
        data['birthdate'] = birthdate.toIso8601String().split('T')[0];
      }

      return await _dio.post(
        '/update-profile',
        data : data,
        options : Options(
          headers : {'Authorization' : 'Bearer $token'},
        ),
      );
    }

    Future<UserProfileDisplay> fetchUserProfile() async {
      final token = await getToken();
      final response = await _dio.get(
        '/me',
        options : Options(
          headers : {'Authorization' : 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200){
        return UserProfileDisplay.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch user profile');
      }
    }

  
}