import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../providers/feedback_provider.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  int _rating = 0;
  final TextEditingController _controller = TextEditingController();
  // bool _isSubmitting = false;

  void _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a rating")),
      );
      return;
    }

    await ref.read(feedbackProvider.notifier).sendFeedback(
      _rating, 
      _controller.text.trim().isEmpty ? null : _controller.text.trim()
    );

    if (!mounted) return;

    final state = ref.read(feedbackProvider);


    if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${state.error.toString()}")),
        );
      } else if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Thank you for your feedback!"),
          backgroundColor: Palette.indigoPrimary,
          ),
        );
      }

    }

  @override
  Widget build(BuildContext context) {

    final feedbackState = ref.watch(feedbackProvider);
    final isSubmitting = feedbackState is AsyncLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Share Feedback")),
      backgroundColor: Palette.iceWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("How is your experience with Moodlens?", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Your feedback helps us grow.", style: TextStyle(color: Palette.slateHeading, letterSpacing: 1.5, fontWeight: FontWeight.w500, fontSize: 16)),
            const SizedBox(height: 30),
            
            // Star Rating Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Icon(
                    index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: index < _rating ? Colors.amber : Palette.bodyGrey,
                    size: 48,
                  ),
                );
              }),
            ),
            Center(
              child: Text(
                _rating == 0 ? "Tap a star" : ["Bad", "Poor", "Average", "Good", "Excellent"][_rating - 1],
                style: const TextStyle(fontWeight: FontWeight.w600, color: Palette.indigoPrimary),
              ),
            ),
            
            const SizedBox(height: 40),
            const Text("Tell us more (Optional)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "What can we improve?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: Palette.indigoPrimary),
                child: isSubmitting 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Submit Feedback", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}