class JournalEntry{
  final int id;
  final String title;
  final String? content;
  final String primaryEmotion;
  final String? secondaryEmotion;
  final double confidenceScore;
  final DateTime createdAt;
  final DateTime? updatedAt;

  JournalEntry({
    required this.id,
    required this.title,
    this.content,
    required this.primaryEmotion,
    this.secondaryEmotion,
    required this.confidenceScore,
    required this.createdAt,
    this.updatedAt,
  });

  factory JournalEntry.fromJson(Map<String,dynamic> json){
    return JournalEntry(
      id : json['id'],
      title : json['title'],
      content : json['content'] ?? "",
      primaryEmotion : json['primary_emotion'],
      secondaryEmotion : json['secondary_emotion'],
      confidenceScore : json['confidence_score'].toDouble(),
      createdAt : DateTime.parse(json['created_at']).toLocal(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']).toLocal() 
          : null,
    );
  }
}


class JournalListResponse{
  final List<JournalEntry> entries;
  final int totalCount;

JournalListResponse({
  required this.entries,
  required this.totalCount,
});

factory JournalListResponse.fromJson(Map<String,dynamic> json){

  return JournalListResponse(
    entries : (json['entries'] as List)
             .map((e) => JournalEntry.fromJson(e))
             .toList(),
    totalCount : json['total_count'],
  );
}

}

