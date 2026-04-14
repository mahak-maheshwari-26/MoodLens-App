import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/admin_service.dart';

part 'admin_provider.g.dart';

@riverpod
class AdminDashboard extends _$AdminDashboard {
  @override
  FutureOr<Map<String, dynamic>> build() async {
    return ref.watch(adminServiceProvider).fetchAdminDashboardData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(adminServiceProvider).fetchDashboardData());
  }
}


@riverpod
class FeedbackAnalytics extends _$FeedbackAnalytics {
  @override
  FutureOr<Map<String, dynamic>> build() async {
    return ref.watch(adminServiceProvider).fetchFeedbackAnalytics();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(adminServiceProvider).fetchFeedbackAnalytics());
  }
}