import 'package:flutter/material.dart';
import 'package:flutter_frontend/core/widgets/recent_reflection_card.dart';
import 'package:flutter_frontend/features/journal/providers/journal_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/app_theme.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  String _getAppreciationMessage(int count) {
    if (count == 0) return "Every journey starts with a single word.";
    if (count < 5) return "You're finding your voice. Keep going!";
    if (count < 20) return "Consistency is key. You're doing amazing!";
    return "Master of Mindfulness. Your soul is shining!";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(journalStatsProvider);

    return Scaffold(
      backgroundColor: Palette.iceWhite,
      appBar: AppBar(
        title: const Text("Growth Insights", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: statsAsync.when(
        data: (stats) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(stats.totalCount),
              const SizedBox(height: 40),
              
              const Text("Emotion Distribution", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildPieChartWithLegend(stats.moodDistribution),
              
              const SizedBox(height: 40),
              
              const Text("Mindfulness Grid", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text("Consistency over the last 12 weeks", style: TextStyle(fontSize: 12, color: Palette.bodyGrey)),
              const SizedBox(height: 15),
              

              Container(
                height: 180, // Fixed height for 7 rows
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _buildHeatmap(stats.heatmap),
              ),
              
              const SizedBox(height: 50), 
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error loading stats: $err")),
      ),
    );
  }

  Widget _buildSummaryCard(int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: AppGradients.indigoGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 75, 33, 243).withValues(alpha: 0.3), 
            blurRadius: 20, 
            offset: const Offset(5, 10)
          )
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
          const SizedBox(height: 10),
          Text("$total", style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w900)),
          const Text("Reflections Authored", style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2), 
              borderRadius: BorderRadius.circular(20)
            ),
            child: Text(
              _getAppreciationMessage(total),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartWithLegend(List<dynamic> distribution) {
    return Column(
      children: [
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              sectionsSpace: 5,
              centerSpaceRadius: 50,
              sections: distribution.map((item) {
                final color = RecentReflectionCard.getMoodColor(item.emotion);
                return PieChartSectionData(
                  color: color,
                  value: item.count.toDouble(),
                  title: '',
                  radius: 30,
                  showTitle: false,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: distribution.map((item) {
            final color = RecentReflectionCard.getMoodColor(item.emotion);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text("${item.emotion}: ${item.count}", 
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Palette.slateHeading)),
              ],
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildHeatmap(List<dynamic> heatmap) {
    final Map<String, int> activity = {for (var h in heatmap) h['date']: h['count']};
    final List<String> weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      children: [
        // Day Labels (M, T, W...)
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekDays.map((d) => Text(d, 
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Palette.bodyGrey))).toList(),
        ),
        const SizedBox(width: 12),
        
        // The Grid: 12 Columns (Weeks) x 7 Rows (Days)
        Expanded(
          child: GridView.builder(
            scrollDirection: Axis.horizontal, 
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // Vertical Rows
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: 84, // 12 weeks * 7 days
            itemBuilder: (context, index) {
              final date = DateTime.now().subtract(Duration(days: 83 - index));
              final dateStr = date.toString().split(' ')[0];
              final count = activity[dateStr] ?? 0;

              return Container(
                decoration: BoxDecoration(
                  color: Palette.indigoPrimary.withValues(
                    alpha: count > 0 ? (0.2 + (count * 0.2)).clamp(0, 1) : 0.08
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}