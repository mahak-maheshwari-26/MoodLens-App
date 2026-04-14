import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/feedback_service.dart';

part 'feedback_provider.g.dart';

@riverpod
class FeedbackNotifier extends _$FeedbackNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> sendFeedback(int rating, String? comment) async {
    state = const AsyncLoading();
    try {
      await ref.read(feedbackServiceProvider).submitFeedback(
        rating: rating,
        comment: comment,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}