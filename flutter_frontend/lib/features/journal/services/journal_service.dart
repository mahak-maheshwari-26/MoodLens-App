import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_frontend/features/journal/models/journal_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/journal_stats_model.dart';

part 'journal_service.g.dart';

@riverpod
JournalService journalService(Ref ref)=> JournalService();

class JournalService{
  
  final _dio = Dio(BaseOptions(
    baseUrl: kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000',
    connectTimeout : const Duration(seconds : 10),
    receiveTimeout : const Duration(seconds : 10),
  ));


  final _storage = FlutterSecureStorage();

  // Get JWT Token
  Future<String?> _getToken() async => await _storage.read(key : 'jwt_token');
  
  // Create a new journal entry
  Future<JournalEntry> createJournal(String title , String content) async{
    final token = await _getToken();

    final response = await _dio.post(
      '/journals/',
      data : {
        'title' : title,
        'content' : content,
      },
      options : Options(
        headers : {'Authorization' : 'Bearer $token'},
      ),
    );

    if (response.statusCode == 200){
      return JournalEntry.fromJson(response.data);
    }
    else{
      throw Exception('Failed to create journal entry');
    }
  }

  // Get journal data for month , year
  Future<JournalListResponse> fetchJournals({int? month , int? year}) async {

    final token = await _getToken();

    // Month and Year parameters are optional
    final Map<String,dynamic> filterParams = {};
    if (month != null) filterParams['month'] = month;
    if (year != null) filterParams['year'] = year;

    final response = await _dio.get(
      '/journals/',
      queryParameters: filterParams,
      options : Options(
        headers : {'Authorization' : 'Bearer $token'},
      ),
    );

    if(response.statusCode == 200){
      return JournalListResponse.fromJson(response.data);
    }
    else{
      throw Exception('Failed to fetch journals');
    }
  }

  // Get fetch recent journals (7 days)
  Future<JournalListResponse> fetchRecentJournals() async{
    final token = await _getToken();
    final response = await _dio.get(
      '/journals/recent',
      options : Options(headers : {'Authorization': 'Bearer $token'}),
    );

    return JournalListResponse.fromJson(response.data);
  }


  // Get : fetching stats

  Future<JournalStats> fetchJournalStats() async{
    final token = await _getToken();

    final response = await _dio.get(
      '/journals/stats',
      options : Options(headers : {'Authorization' : 'Bearer $token'}),
    );

    if (response.statusCode == 200){
      return JournalStats.fromJson(response.data);
    }
    else{
      throw Exception("Failed to fetch Statistics");
    }
  }

  Future<JournalEntry> updateJournal(int id, String content) async {
  final token = await _getToken();
  final response = await _dio.put(
    '/journals/$id',
    data: {'content': content},
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
  return JournalEntry.fromJson(response.data);
 }

  Future<JournalEntry> fetchJournalById(int id) async {
  final token = await _getToken();
  final response = await _dio.get(
    '/journals/$id',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
  return JournalEntry.fromJson(response.data);
 }

  Future<void> deleteJournal(int id) async {
    final token = await _getToken();
    await _dio.delete(
      '/journals/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}