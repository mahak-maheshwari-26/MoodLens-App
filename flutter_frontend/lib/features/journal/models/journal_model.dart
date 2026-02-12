class JournalEntry{
  final int id;
  final String title;
  final String content;
  final String primaryEmotion;
  final String? secondaryEmotion;
  final double confidenceScore;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.primaryEmotion,
    this.secondaryEmotion,
    required this.confidenceScore,
    required this.createdAt,
  });

  factory JournalEntry.fromJson(Map<String,dynamic> json){
    return JournalEntry(
      id : json['id'],
      title : json['title'],
      content : json['content'],
      primaryEmotion : json['primary_emotion'],
      secondaryEmotion : json['secondary_emotion'],
      confidenceScore : json['confidence_score'].toDouble(),
      createdAt : DateTime.parse(json['created_at']),
    );
  }
}

