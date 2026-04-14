import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/services/auth_service.dart';

part 'feedback_service.g.dart';

@riverpod
FeedbackService feedbackService(Ref ref) => FeedbackService(ref);

class FeedbackService {
  final Ref _ref;
  final _dio = Dio(BaseOptions(
    baseUrl: kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  FeedbackService(this._ref);

  Future<void> submitFeedback({required int rating, String? comment}) async {
    final authService = _ref.read(authServiceProvider);
    final token = await authService.getToken();

    try {
      await _dio.post(
        '/feedback',
        data: {
          'rating': rating,
          'comment': comment,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      String errorMessage = "Failed to submit feedback";
  
  if (e.response?.data is Map) {
    errorMessage = e.response?.data['detail']?.toString() ?? errorMessage;
  } else if (e.response?.data is String) {
    errorMessage = e.response?.data;
  }
  
  throw errorMessage;
      // throw e.response?.data['detail'] ?? "Failed to submit feedback";
    }
  }
}