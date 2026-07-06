import 'package:flutter_frontend/features/journal/models/journal_model.dart';
import 'package:flutter_frontend/features/journal/models/journal_stats_model.dart';
import 'package:flutter_frontend/features/journal/services/journal_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'journal_provider.g.dart';


// New provider for recent journals (for dashboard)
@riverpod
Future<JournalListResponse> recentJournals(Ref ref) async{
  return await ref.watch(journalServiceProvider).fetchRecentJournals();
} 

// New provider for the stats (chart and heatmap)
@riverpod
Future<JournalStats> journalStats(Ref ref) async{
  return await ref.watch(journalServiceProvider).fetchJournalStats();
}



@Riverpod(keepAlive: true)
class JournalNotifier extends _$JournalNotifier{

    @override
    FutureOr<JournalListResponse> build(){

      // Automatically fetches current month at start
      return ref.watch(journalServiceProvider).fetchJournals();
    }

    // Create a new journal entry
    Future<void> createEntry(String title , String content) async{
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
              await ref.read(journalServiceProvider).createJournal(title,content);
              // After creating re-fetch the list
              return await ref.read(journalServiceProvider).fetchJournals();
        });

        // invalidate stats and recent journals
        ref.invalidate(journalStatsProvider);
        ref.invalidate(recentJournalsProvider);
    }

    // Filter by month and year
    Future<void> updateFilter(int month, int year) async{
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
              return await ref.read(journalServiceProvider).fetchJournals(
                month : month,
                year : year
              );
      });
    }

    Future<void> updateEntry(int id, String content) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(journalServiceProvider).updateJournal(id, content);
      return await ref.read(journalServiceProvider).fetchJournals();
    });
    ref.invalidate(recentJournalsProvider);
    ref.invalidate(journalStatsProvider);
  }

  Future<void> deleteEntry(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(journalServiceProvider).deleteJournal(id);
      return await ref.read(journalServiceProvider).fetchJournals();
    });
    ref.invalidate(recentJournalsProvider);
    ref.invalidate(journalStatsProvider);
  }
}


