import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/journal/models/journal_model.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_theme.dart';

class RecentReflectionCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onTap;

  const RecentReflectionCard({super.key, required this.entry, required this.onTap});

  static Color getMoodColor(String emotion) {
    return switch (emotion.toLowerCase()) {
      'joy' => Palette.joy,
      'sadness' => Palette.sadness,
      'anger' => Palette.anger,
      'fear' => Palette.fear,
      'disgust' => Palette.disgust,
      'shame' => Palette.shame,
      'guilt' => Palette.guilt,
      _ => Palette.neutral,
    };
  }

  @override
  Widget build(BuildContext context) {

    final String confidence = "${(entry.confidenceScore * 100).toStringAsFixed(0)}%";
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(entry.title ?? "Untitled",
                      overflow: TextOverflow.ellipsis,
                      maxLines : 1,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Palette.slateHeading)),
                ),
                Text(DateFormat('d MMM').format(entry.createdAt.toLocal()),
                    style: const TextStyle(color: Palette.slateHeading, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _MoodBadge(emotion: entry.primaryEmotion ?? 'Neutral'),
                if (entry.secondaryEmotion != null) ...[
                  const SizedBox(width: 8),
                  _MoodBadge(emotion: entry.secondaryEmotion!),
                ],
                const Spacer(),
                Text(confidence, style: const TextStyle(fontWeight: FontWeight.bold, color: Palette.indigoPrimary, fontSize: 14)),
                const Icon(Icons.bolt, size: 14, color: Palette.indigoPrimary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodBadge extends StatelessWidget {
  final String emotion;
  const _MoodBadge({required this.emotion});

  @override
  Widget build(BuildContext context) {

    final moodColor = RecentReflectionCard.getMoodColor(emotion);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: moodColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(emotion.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Palette.slateHeading.withValues(alpha: 0.8))),
    );
  }
}