
// for stats page - for charts a single component
class MoodDistribution{
  final String emotion;
  final int count;

  MoodDistribution({required this.emotion, required this.count});

  factory MoodDistribution.fromJson(Map<String,dynamic> json){
    return MoodDistribution(
      emotion : json['emotion'],
      count: json['count'],
    );
  }
}


// for heatmap in stats page
class JournalStats{
  final int totalCount;
  final List<Map<String,dynamic>> heatmap;
  final List<MoodDistribution> moodDistribution;

  JournalStats({
    required this.totalCount,
    required this.heatmap,
    required this.moodDistribution,
  });

  factory JournalStats.fromJson(Map<String, dynamic> json){
    return JournalStats(
      totalCount : json['total_journal_count'],
      heatmap : List<Map<String,dynamic>>.from(json['heatmap']),
      moodDistribution : (json['mood_distribution'] as List)
          .map((i) => MoodDistribution.fromJson(i))
          .toList(),
    );
  }
}