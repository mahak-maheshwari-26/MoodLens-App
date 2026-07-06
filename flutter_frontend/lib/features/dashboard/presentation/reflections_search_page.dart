import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/journal/providers/journal_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/journal_details_modal.dart';
import '../../../core/widgets/recent_reflection_card.dart';
import '../../../theme/app_theme.dart';

class ReflectionsSearchPage extends ConsumerStatefulWidget {
  const ReflectionsSearchPage({super.key});

  @override
  ConsumerState<ReflectionsSearchPage> createState() => _ReflectionsSearchPageState();
}

class _ReflectionsSearchPageState extends ConsumerState<ReflectionsSearchPage> {
  String searchQuery = "";
  String? selectedEmotion;
  String selectedTimeRange = "All"; // All, Week, Month

  @override
  Widget build(BuildContext context) {
    final journalState = ref.watch(journalProvider);

    return Scaffold(
      // backgroundColor: Palette.iceWhite,
      backgroundColor: Palette.cardIndigoTint,
      appBar: AppBar(
        title: const Text("Search Reflections", style: TextStyle(color: Palette.slateHeading, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Palette.slateHeading),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: InputDecoration(
                hintText: "Search by title or content...",
                prefixIcon: const Icon(Icons.search, color: Palette.indigoPrimary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Filters (Emotions & Time)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip("All Time", selectedTimeRange == "All", () => setState(() => selectedTimeRange = "All")),
                _buildFilterChip("Past Week", selectedTimeRange == "Week", () => setState(() => selectedTimeRange = "Week")),
                _buildFilterChip("Past Month", selectedTimeRange == "Month", () => setState(() => selectedTimeRange = "Month")),
              ],
            ),
          ),

          const SizedBox(height: 8),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['Joy', 'Sadness', 'Anger', 'Fear', 'Disgust', 'Shame', 'Guilt'].map((e) => 
                _buildFilterChip(
                  e, 
                  selectedEmotion == e, 
                  () => setState(() => selectedEmotion = (selectedEmotion == e ? null : e))
                )
              ).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // Results List
          Expanded(
            child: journalState.when(
              data: (data) {
                // APPLY FILTERS
                final filteredList = data.entries.where((entry) {
                  final matchesSearch = entry.title.toLowerCase().contains(searchQuery.toLowerCase()) || 
                                      entry.content!.toLowerCase().contains(searchQuery.toLowerCase());
                  final matchesEmotion = selectedEmotion == null || entry.primaryEmotion.toLowerCase() == selectedEmotion!.toLowerCase();
                  
                  // Time Filter
                  bool matchesTime = true;
                  final now = DateTime.now();

                  if (selectedTimeRange == "Week") {
                    matchesTime = entry.createdAt.isAfter(now.subtract(const Duration(days: 7)));
                  } else if (selectedTimeRange == "Month") {
                    // matchesTime = entry.createdAt.isAfter(now.subtract(const Duration(days: 30)));
                    final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
                    final firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
                  
                    matchesTime = entry.createdAt.isAfter(firstDayOfLastMonth) && 
                                  entry.createdAt.isBefore(firstDayOfCurrentMonth);
                  }

                  return matchesSearch && matchesEmotion && matchesTime;
                }).toList();

                if (filteredList.isEmpty) {
                  return const Center(child: Text("No reflections found."));
                }

                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final entry = filteredList[index];
                    return RecentReflectionCard(
                      entry: entry,
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => JournalDetailsModal(entry: entry),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => const Center(child: Text("Error loading entries")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        selectedColor: Palette.indigoPrimary.withValues(alpha: 0.2),
        labelStyle: TextStyle(
          color: isSelected ? Palette.indigoPrimary : Palette.bodyGrey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}