import 'package:flutter/material.dart';
import 'package:flutter_frontend/core/widgets/journal_details_modal.dart';
import 'package:flutter_frontend/core/widgets/recent_reflection_card.dart';
import 'package:flutter_frontend/features/auth/providers/auth_provider.dart';
import 'package:flutter_frontend/screens/demo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_theme.dart';
import '../../journal/providers/journal_provider.dart';

class MainDashboard extends ConsumerWidget {
  const MainDashboard({super.key});

  // Helper for dynamic greeting
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to leave?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Stay",style: TextStyle(color: Palette.slateHeading),)),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout(); 
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text("Logout", style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account", style: TextStyle(color: Colors.red)),
        content: const Text("This is permanent. All your reflections will be lost forever."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              // Delete logic here
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching user profile
    final userProfileState = ref.watch(userProfileProvider);
    
    // Watching recent journals
    final recentJournalsState = ref.watch(recentJournalsProvider);


    return Scaffold(
      backgroundColor: Palette.iceWhite,
      drawerEdgeDragWidth: 20,
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              userProfileState.when(
          data: (profile) => UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppGradients.etherealBackground,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                // Shows the first letter of their name as a placeholder
                profile.fullName[0].toUpperCase(),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Palette.indigoPrimary),
              ),
            ),
            accountName: Text(
              profile.fullName, 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Palette.slateHeading),
            ),
            accountEmail: Text(
              profile.email,
              style: const TextStyle(color: Palette.slateHeading),
            ),
          ),

          loading: () => const DrawerHeader(
            decoration: BoxDecoration(color: Palette.indigoPrimary),
            child: Center(child: CircularProgressIndicator(color: Colors.white)),
          ),

          error: (err, _) => const UserAccountsDrawerHeader(
            accountName: Text("Journal User"),
            accountEmail: Text("Check connection"),
          ),
        ),
        
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text("Profile"),
          onTap: () {
            Navigator.pop(context); // Close drawer
            // Navigator.pushNamed(context, '/profile');
          },
        ),
        
        const Spacer(), 
        const Divider(),
        
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.orange),
          title: const Text("Logout"),
          onTap: () => _showLogoutDialog(context, ref),
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: const Text("Delete Account", style: TextStyle(color: Colors.red)),
          onTap: () => _showDeleteAccountDialog(context, ref),
        ),
        const SizedBox(height: 20),
      ],
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.etherealBackground),
        child: SafeArea(
          child: CustomScrollView(

            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userProfileState.when(
                        data: (profile) => Text(
                          "${_getGreeting()}, ${profile.fullName}", 
                          style: const TextStyle(fontSize: 16, color: Palette.bodyGrey, fontWeight: FontWeight.w600),
                        ),
                        loading:() => const Text("Loading...", style: TextStyle(fontSize: 16, color: Palette.bodyGrey, fontWeight: FontWeight.w600)),
                        error : (err,_) => Text("${_getGreeting()}, Friend"),

                      ),
                      
                      const Text("Your Mood Journey",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Palette.slateHeading)),
                    ],
                  ),
                ),
              ),

              // Recent Moods
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 120,
                    child: recentJournalsState.when(
                      data: (data) => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: data.entries.length,
                        itemBuilder: (context, index) {
                          final entry = data.entries[index];
                          return _MoodDayCard(
                            date: entry.createdAt,
                            emotion: entry.primaryEmotion ?? 'neutral',
                          );
                        },
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Center(child: Text("Start journaling to see trends!")),
                    ),
                  ),
                ),
              ),

              // Journal List
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("Recent Reflections", 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),

              recentJournalsState.when(
                  data: (data) => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = data.entries[index];
                        return RecentReflectionCard(
                          entry: entry,
                          onTap: () {

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => JournalDetailsModal(entry: entry),
                            );
                          },
                        );
                      },
                      childCount: data.entries.length,
                    ),
                  ),

                loading: () => const SliverToBoxAdapter(
                  child: Center(child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  )),
                ),

                error: (err, stack) => const SliverToBoxAdapter(
                  child: Center(child: Text("Could not load reflections")),
                ),
              ),

            ],
          ),
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottomBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-journal'),
        backgroundColor: Palette.indigoPrimary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Palette.surfaceGlass,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.dashboard_rounded, color: Palette.indigoPrimary),
              onPressed: () {},
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.bar_chart_rounded, color: Palette.bodyGrey),
              onPressed: () => Navigator.pushNamed(context, '/stats'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodDayCard extends StatelessWidget {
  final DateTime date;
  final String emotion;

  const _MoodDayCard({required this.date, required this.emotion});

  @override
  Widget build(BuildContext context) {

    final String dayLabel = DateFormat('d').format(date);
    final String monthLabel = DateFormat('MMM').format(date);
    
    // Map emotion string to color and emoji
    final moodColor = switch (emotion.toLowerCase()) {
      'joy' => Palette.joy,
      'sadness' => Palette.sadness,
      'anger' => Palette.anger,
      'fear' => Palette.fear,
      'disgust' => Palette.disgust,
      'shame' => Palette.shame,
      'guilt' => Palette.guilt,
       _ => Palette.neutral,
    };

    final moodIcon = switch (emotion.toLowerCase()) {
      'joy' => Icons.sentiment_very_satisfied_outlined,
      'sadness' => Icons.sentiment_dissatisfied_outlined,
      'anger' => Icons.sentiment_very_dissatisfied_outlined,
      'fear' => Icons.sentiment_very_dissatisfied_rounded,          
      'disgust' => Icons.mood_bad_outlined,
      'shame' => Icons.sentiment_dissatisfied_rounded,
      'guilt' => Icons.sentiment_neutral_outlined,
      _ => Icons.sentiment_satisfied_outlined,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 75,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Palette.indigoPrimary.withValues(alpha: 0.2),width: 1.5),
          boxShadow: [
            BoxShadow(
              color: moodColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(monthLabel, 
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Palette.bodyGrey)),
            Text(dayLabel, 
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Palette.slateHeading)),
           const SizedBox(height: 6),
            Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: moodColor.withValues(alpha: 0.3), 
            shape: BoxShape.circle,
          ),
          child: Icon(
            moodIcon,
            color: moodColor, // Solid icon color
            size: 30,
          ),
        ),
          ],
        ),
      ),
    );
  }
}