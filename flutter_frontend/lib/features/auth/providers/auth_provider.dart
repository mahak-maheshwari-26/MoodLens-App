import 'package:flutter_frontend/features/auth/models/user_profile_model.dart';

import '../data/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_provider.g.dart';


@Riverpod(keepAlive : true)
class AuthNotifier extends _$AuthNotifier{
  // final _authService = AuthService();

  AuthService get _authService => ref.read(authServiceProvider);

  @override
  FutureOr<String?> build() async{
    // It makes the class AsyncNotifier because its future
    return await _authService.getToken();
  }

  Future<void> signup(String email,String password) async{
    state = const AsyncLoading();

    // AsyncValue.guard handles try and catch
    state = await AsyncValue.guard(() async {
      final response = await _authService.signup(email, password);
      final token = response.data['access_token'];
      await _authService.saveToken(token);
      return token; 
    }); 
  }

  Future<void> login(String email,String password) async{
    state = const AsyncLoading();

    // AsyncValue.guard handles try and catch
    state = await AsyncValue.guard(() async {
      final response = await _authService.login(email, password);
      final token = response.data['access_token'];
      await _authService.saveToken(token);
      return token;
    }); 
  }

  Future<void> logout() async{
    await _authService.logout();
    state = const AsyncData(null);
  }

  //User Profile 
  Future<void> updateProfile({
    required String name,
    DateTime? birthdate,
  }) async{
    // call the service 
    await _authService.updateProfile(
      name : name,
      birthdate : birthdate,
    );
    ref.invalidate(userProfileProvider);
  }
}

// A provider for displaying user details on the screen
@riverpod
Future<UserProfileDisplay> userProfile(Ref ref) async {
  // it watches the auth state , if the token changes or disappears it will refetch the user profile

  final auth = ref.watch(authProvider);

  if (auth.value == null) throw Exception("User not logged in");

  return await ref.read(authServiceProvider).fetchUserProfile();
}
