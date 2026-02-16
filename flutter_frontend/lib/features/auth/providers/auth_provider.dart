import 'package:flutter_frontend/features/auth/models/user_profile_model.dart';

import '../services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_provider.g.dart';


@Riverpod(keepAlive : true)
class AuthNotifier extends _$AuthNotifier{

  AuthService get _authService => ref.read(authServiceProvider);

  @override
  FutureOr<String?> build() async{
    // It makes the class AsyncNotifier because its future
    return await _authService.getToken();
  }

  Future<void> signup(String email,String password) async{
    state = const AsyncLoading();

    try {
      final response = await _authService.signup(email, password);
      final token = response.data['access_token'] as String;
      await _authService.saveToken(token);
      
      // FORCE the state update here
      state = AsyncData(token); 
      ref.invalidate(userProfileProvider);
    } catch (e, st) {
      // print("CRITICAL: Signup failed with error: $e");
      state = AsyncError(e, st);
    }
  }

  Future<void> login(String email,String password) async{
    state = const AsyncLoading();

    try {
      final response = await _authService.login(email, password);
      final token = response.data['access_token'] as String;
      await _authService.saveToken(token);
      
      // FORCE the state update here
      state = AsyncData(token);
      ref.invalidate(userProfileProvider);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async{
    await _authService.logout();
    ref.invalidateSelf();
    ref.invalidate(userProfileProvider);
    // state = const AsyncData(null);
  }

  //User Profile 
  Future<void> updateProfile({
    required String name,
    DateTime? birthdate,
  }) async{
      try{
    // call the service 
    await _authService.updateProfile(
      name : name,
      birthdate : birthdate,
    );

  } catch(e) {
      // print("Update Profile Error: $e");
      rethrow;
    }
  }

  // Update Name
  Future<void> updateName(String newName) async{
    try{
      await _authService.updateProfile(name: newName);
    }
    catch(e){
      // print("Error updating name : $e");
      rethrow;
    }
  }
}

// A provider for displaying user details on the screen
@riverpod
Future<UserProfileDisplay> userProfile(Ref ref) async {
  // it watches the auth state , if the token changes or disappears it will refetch the user profile

  final authState = ref.watch(authProvider);
  final token = authState.value;

  if (token == null || token.isEmpty) {
    throw Exception("Token not found Please Log in");
  }

  return await ref.read(authServiceProvider).fetchUserProfile();
}
