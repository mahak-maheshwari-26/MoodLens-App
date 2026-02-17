import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_theme.dart';

/// Data class to hold the emotional insight content
class _EmotionInsight {
  final String title;
  final String message;
  final String quote;
  final String emoji;
  final Color color;

  _EmotionInsight({
    required this.title,
    required this.message,
    required this.quote,
    required this.emoji,
    required this.color,
  });
}

class WeeklyInsightCard extends StatelessWidget {
  final List<dynamic> entries;

  const WeeklyInsightCard({super.key, required this.entries});

  String _getDateRange() {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    
    // Format: "11 Tue - 17 Mon" (using 'd EEE' for date and short day)
    final String start = DateFormat('d EEE').format(sevenDaysAgo);
    final String end = DateFormat('d EEE').format(now);
    
    return "$start - $end";
  }

  // Helper to get Palette color based on emotion string
  Color _getMoodColor(String emotion) {
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

  _EmotionInsight _getInsight(String emotion) {
    return switch (emotion.toLowerCase()) {
      'joy' => _EmotionInsight(
          title: "Radiant Spirit",
          message: "You're in a beautiful flow! Happiness doesn't always need an explanation; it just needs space to be celebrated.",
          quote: "“Joy is the simplest form of gratitude.”",
          emoji: "✨",
          color: Palette.joy,
        ),
      'sadness' => _EmotionInsight(
          title: "Gentle Healing",
          message: "It feels heavy right now. You don't need 'fixing'—you just need permission to be still and breathe through the mist.",
          quote: "“The soul would have no rainbow had the eyes no tears.”",
          emoji: "🌊",
          color: Palette.sadness,
        ),
      'anger' => _EmotionInsight(
          title: "Protective Fire",
          message: "Anger is often a heart protecting itself. Let's transform that heat into clarity and steady boundaries.",
          quote: "“For every minute you are angry, you lose sixty seconds of happiness.”",
          emoji: "🔥",
          color: Palette.anger,
        ),
      'fear' => _EmotionInsight(
          title: "Quiet Bravery",
          message: "Anxiety is loud, but your core is steady. You aren't looking for safety; you are building it within yourself.",
          quote: "“Courage is being scared to death, but saddling up anyway.”",
          emoji: "🛡️",
          color: Palette.fear,
        ),
      'disgust' => _EmotionInsight(
          title: "Inner Boundaries",
          message: "You're sensing what doesn't align with your soul. Trust your intuition to guide you toward what feels true.",
          quote: "“Integrity is choosing courage over comfort.”",
          emoji: "🍃",
          color: Palette.disgust,
        ),
      'shame' => _EmotionInsight(
          title: "Soft Grace",
          message: "We all have shadows. Instead of hiding, try looking at yourself with the same mercy you'd give a best friend.",
          quote: "“You are enough just as you are.”",
          emoji: "🤍",
          color: Palette.shame,
        ),
      'guilt' => _EmotionInsight(
          title: "A Path Forward",
          message: "Guilt is a teacher, not a prison. Learn the lesson it offers, then give yourself permission to move on.",
          quote: "“Forgiveness is the fragrance the violet sheds on the heel that has crushed it.”",
          emoji: "⚓",
          color: Palette.guilt,
        ),
      _ => _EmotionInsight(
          title: "Steady Journey",
          message: "You are finding your balance in the everyday. This is the quiet, beautiful work of self-discovery.",
          quote: "“Within you, there is a stillness and a sanctuary.”",
          emoji: "🧘",
          color: Palette.neutral,
        ),
    };
  }

  void _showDetailedAnalysis(BuildContext context, Map<String, int> counts, _EmotionInsight insight) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Text(_getDateRange(), style: TextStyle(color: Palette.slateHeading, fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: 0.5)),
            const SizedBox(height: 8),
            Text(insight.emoji, style: const TextStyle(fontSize: 54)),
            const SizedBox(height: 8),
            Text(insight.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Palette.slateHeading)),
            const SizedBox(height: 24),
            
            // Large Pie Chart
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                  sections: counts.entries.map((entry) {
                    final isDominant = entry.key == insight.title.toLowerCase();
                    return PieChartSectionData(
                      color: _getMoodColor(entry.key),
                      value: entry.value.toDouble(),
                      title: '${((entry.value / entries.length) * 100).toInt()}%',
                      radius: isDominant ? 60 : 50,
                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Legend Grid
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: counts.keys.map((emotion) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: _getMoodColor(emotion), shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Text(emotion[0].toUpperCase() + emotion.substring(1), style: const TextStyle(fontSize: 14, color: Palette.slateHeading)),
                ],
              )).toList(),
            ),

            const SizedBox(height: 32),
            Text(insight.message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.5, color: Palette.slateHeading)),
            const SizedBox(height: 24),
            
            // Quote Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: insight.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: insight.color.withValues(alpha: 0.2)),
              ),
              child: Text(
                insight.quote,
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, color: Palette.slateHeading.withValues(alpha: 0.8), fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    final Map<String, int> counts = {};
    for (var e in entries) {
      final em = (e.primaryEmotion ?? 'neutral').toLowerCase();
      counts[em] = (counts[em] ?? 0) + 1;
    }

    final dominantEmotion = counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    final insight = _getInsight(dominantEmotion);

    return Padding(
      padding: const EdgeInsets.all(20),
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () => _showDetailedAnalysis(context, counts, insight),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: insight.color.withValues(alpha: 0.2), width: 1.5),
            boxShadow: [
              BoxShadow(color: insight.color.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: Row(
            children: [
              // Small Decorative Pie Chart
              SizedBox(
                width: 55,
                height: 55,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 14,
                    sections: counts.entries.map((entry) {
                      return PieChartSectionData(
                        color: _getMoodColor(entry.key),
                        value: entry.value.toDouble(),
                        radius: 16,
                        showTitle: false,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getDateRange(),
                      style: TextStyle(
                        fontSize: 14, 
                        fontWeight: FontWeight.w600, 
                        color: Palette.slateHeading.withValues(alpha: 0.8),
                        letterSpacing: 0.5
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Weekly Insight: ${insight.title}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Palette.slateHeading),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      insight.message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: Palette.bodyGrey, height: 1.3),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: insight.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  insight.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              // Icon(Icons.auto_awesome_rounded, size: 20, color: insight.color.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}