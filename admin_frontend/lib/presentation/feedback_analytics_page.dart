import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../provider/admin_provider.dart';
import '../theme/app_theme.dart';

class FeedbackAnalyticsPage extends ConsumerStatefulWidget {
  const FeedbackAnalyticsPage({super.key});

  @override
  ConsumerState<FeedbackAnalyticsPage> createState() => _FeedbackAnalyticsPageState();
}

class _FeedbackAnalyticsPageState extends ConsumerState<FeedbackAnalyticsPage> {
  String ratingFilter = "All Ratings";
  String monthFilter = "All Months"; 

  final List<String> monthNames = [
    "All Months", "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Listen to the specific Feedback provider instead of the general dashboard one
    final feedbackAsync = ref.watch(feedbackAnalyticsProvider);

    return Scaffold(
      backgroundColor: Palette.iceWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Feedback & Trends", 
          style: TextStyle(color: Palette.deepSpace, fontWeight: FontWeight.bold)),
      ),
      body: feedbackAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Palette.indigoPrimary)),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (data) {
          // Use the 'all_feedbacks' key from your new backend endpoint
          final feedbacks = data['all_feedbacks'] as List;
          final trendData = data['monthly_trend'] as List; // Trend data from backend
          
          final filteredFeedback = feedbacks.where((f) {
            // if (ratingFilter == "All Ratings") return true;
            // return f['rating'].toString() == ratingFilter[0];
            bool matchesRating = true;
    if (ratingFilter != "All Ratings") {
      matchesRating = f['rating'].toString() == ratingFilter[0];
    }

    // 2. Month Filter
    bool matchesMonth = true;
    if (monthFilter != "All Months" && f['date'] != null) {
      DateTime date = DateTime.parse(f['date'].toString());
      int selectedMonthIndex = monthNames.indexOf(monthFilter);
      matchesMonth = date.month == selectedMonthIndex;
    }
    return matchesRating && matchesMonth;

    }).toList();
    filteredFeedback.sort((a, b) => (b['date'] ?? "").compareTo(a['date'] ?? ""));

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Pass trendData to the chart
                        _buildTrendSection(feedbacks), 
                        const SizedBox(height: 24),
                        _buildRatingDistribution(feedbacks),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _buildFeedbackHeader(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Container(
                          decoration: _boxDecoration(),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.separated(
                              itemCount: filteredFeedback.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (context, index) => _buildFeedbackTile(filteredFeedback[index]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendSection(List feedbacks) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(24),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Monthly Feedback Volume", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Expanded(child: SizedBox(height: 20)),
          Expanded(
            flex: 8,
            child: LineChart(_mainLineChartData(feedbacks)), // Using your helper
          ),
        ],
      ),
    );
  }
  Widget _buildRatingDistribution(List feedbacks) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Rating Breakdown", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 20),
          // Simple Bar representaton
          for (int i = 5; i >= 1; i--) _buildRatingBar(i, feedbacks),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int star, List all) {
    final count = all.where((f) => f['rating'] == star).length;
    final percent = all.isEmpty ? 0.0 : count / all.length;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text("$star Stars", style: const TextStyle(fontSize: 12))),
          Expanded(
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Palette.iceWhite,
              color: star >= 4 ? Palette.cyanGlow : (star == 3 ? Palette.indigoPrimary : Colors.orangeAccent),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          Text("$count", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFeedbackTile(Map f) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(f['user'] ?? "Anonymous", style: const TextStyle(fontWeight: FontWeight.bold, color: Palette.indigoPrimary)),
            _buildStarBadge(f['rating']),
          ],
        ),
        const SizedBox(height: 8),
        Text(f['comment'] ?? "No comment provided.", style: const TextStyle(color: Palette.deepSpace, fontSize: 14)),
        const SizedBox(height: 8),
        Text(f['date']?.toString().split('T')[0] ?? "", style: const TextStyle(color: Palette.bodyGrey, fontSize: 11)),
      ],
    );
  }

  Widget _buildStarBadge(int rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Palette.cyanGlow.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          const Icon(Icons.star, size: 14, color: Palette.indigoPrimary),
          Text(" $rating", style: const TextStyle(fontWeight: FontWeight.bold, color: Palette.indigoPrimary)),
        ],
      ),
    );
  }

  Widget _buildFeedbackHeader() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("User Comments", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Row(
        children: [
          // Rating Filter
          Expanded(
            child: _filterDropdown(
              value: ratingFilter,
              items: ["All Ratings", "5 Stars", "4 Stars", "3 Stars", "2 Stars", "1 Star"],
              onChanged: (v) => setState(() => ratingFilter = v!),
            ),
          ),
          const SizedBox(width: 8),
          // Month Filter
          Expanded(
            child: _filterDropdown(
              value: monthFilter,
              items: monthNames,
              onChanged: (v) => setState(() => monthFilter = v!),
            ),
          ),
        ],
      ),
    ],
  );
}

// Reusable styled dropdown container
Widget _filterDropdown({required String value, required List<String> items, required Function(String?) onChanged}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Palette.iceWhite, width: 2),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Palette.indigoPrimary),
        style: const TextStyle(fontSize: 12, color: Palette.deepSpace, fontWeight: FontWeight.w600),
        items: items.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
        onChanged: onChanged,
      ),
    ),
  );
}
  
  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))],
  );
}

// Helper to convert backend data to Chart Spots
  List<FlSpot> _getMonthlySpots(List feedbacks) {
    // Initialize map for all months to 0 to ensure the line is continuous
    Map<int, int> monthlyCounts = { for (var i = 1; i <= 12; i++) i : 0 };
    
    for (var f in feedbacks) {
      if (f['date'] != null) {
        DateTime date = DateTime.parse(f['date'].toString());
        monthlyCounts[date.month] = (monthlyCounts[date.month] ?? 0) + 1;
      }
    }

    // We only want to show spots for months that have passed or have data
    // Sort them by month order
    List<int> sortedMonths = monthlyCounts.keys.toList()..sort();
    return sortedMonths.map((m) => FlSpot(m.toDouble(), monthlyCounts[m]!.toDouble())).toList();
  }

  LineChartData _mainLineChartData(List feedbacks) {
    final spots = _getMonthlySpots(feedbacks);

    return LineChartData(
      // 1. TOOLTIP LOGIC (The "15 Feedbacks in March" popup)
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black,
          // getTooltipColor: (touchedSpot) => Palette.deepSpace,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              const months = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
              final monthName = months[touchedSpot.x.toInt()];
              return LineTooltipItem(
                "$monthName: ${touchedSpot.y.toInt()} Feedbacks",
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
      
      gridData: const FlGridData(show: false),
      
      // 2. AXIS LABELS (Month Names)
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              const months = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
              if (value >= 1 && value <= 12) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 8,
                  child: Text(months[value.toInt()], style: const TextStyle(fontSize: 10, color: Palette.bodyGrey)),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10, color: Palette.bodyGrey)),
            reservedSize: 28,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      
      borderData: FlBorderData(show: false),
      
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Palette.indigoPrimary,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 4,
              color: Colors.white,
              strokeWidth: 2,
              strokeColor: Palette.indigoPrimary,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [Palette.indigoPrimary.withValues(alpha: 0.2), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }