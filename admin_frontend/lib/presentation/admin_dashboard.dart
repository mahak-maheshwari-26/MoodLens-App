import 'package:admin_frontend/presentation/admin_login.dart';
import 'package:admin_frontend/presentation/feedback_analytics_page.dart';
import 'package:admin_frontend/presentation/user_management_page.dart';
import 'package:admin_frontend/provider/admin_provider.dart';
import 'package:admin_frontend/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  void _handleLogout(BuildContext context, WidgetRef ref) async {
    // Accessing logout from service
    await ref.read(adminServiceProvider).logout();
    if (context.mounted) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const AdminLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(adminDashboardProvider);

    return Scaffold(
      backgroundColor: Palette.iceWhite,
      body: Row(
        children: [
          _buildSidebar(context, ref),
          
          Expanded(
            child: dashboardAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text("Sync Error: $err")),
              data: (data) => _buildScrollableContent(ref, data),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableContent(WidgetRef ref, Map<String, dynamic> data) {
    final stats = data['stats'];
    final users = data['users'] as List;
    final feedbacks = data['feedbacks'] as List;
    final ageDist = data['age_dist'] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(ref),
          const SizedBox(height: 32),
          
          Row(
            children: [
              _statCard("Total Users", stats['total_users'].toString(), Icons.people_alt_rounded, Palette.indigoPrimary),
              const SizedBox(width: 20),
              _statCard("Total Feedback", stats['total_feedback'].toString(), Icons.chat_bubble_rounded, Palette.violetAccent),
              const SizedBox(width: 20),
              _statCard("New (This Week)", stats['new_users_last_week'].toString(), Icons.person_add, Palette.cyanGlow),
              const SizedBox(width: 20),
              _statCard("Avg. Rating", "4.8", Icons.star_rounded, Palette.cyanGlow),
              const SizedBox(width: 20),
              _statCard("Total Journals", stats['total_journals'].toString(), Icons.book, Palette.violetAccent),
            ],
          ),
          
          const SizedBox(height: 32),
          
          LayoutBuilder(builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 1100;
            return Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                _contentBox(
                  title: "User Demographics (Age)",
                  width: isWide ? (constraints.maxWidth * 0.45) : constraints.maxWidth,
                  child: _buildAgePie(ageDist),
                ),
                _contentBox(
                  title: "Recent User Feedback",
                  width: isWide ? (constraints.maxWidth * 0.51) : constraints.maxWidth,
                  child: _buildFeedbackList(feedbacks),
                ),
              ],
            );
          }),
          
          const SizedBox(height: 32),
          _buildUserTable(users),
        ],
      ),
    );
  }

  // Updated method signature to accept ref
  Widget _buildSidebar(BuildContext context, WidgetRef ref) {
    return Container(
      width: 280,
      color: Palette.deepSpace,
      child: Column(
        children: [
          const SizedBox(height: 60),
          const Text("MOODLENS", 
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2)),
          const Text("COMMAND CENTER", 
            style: TextStyle(color: Palette.cyanGlow, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 60),
          _sidebarItem(Icons.grid_view_rounded, "Dashboard", true, () {}),
          _sidebarItem(Icons.feedback_rounded, "View FeedBack", false, () {
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => const FeedbackAnalyticsPage()));
          }),

          // _sidebarItem(Icons.analytics_outlined, "Analytics", false, () {}),
          _sidebarItem(Icons.people_outline_rounded, "Users", false, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserManagementPage()),
              );
          }),
          // _sidebarItem(Icons.settings_outlined, "Settings", false, () {}),
          const Spacer(),
          // Logout logic now has access to both context and ref
          _sidebarItem(Icons.logout_rounded, "Logout", false, () => _handleLogout(context, ref)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Palette.indigoPrimary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? Palette.cyanGlow : Colors.white38),
        title: Text(label, 
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white38, 
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal
          )),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAgePie(Map<String, dynamic> ageDist) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 60,
        sectionsSpace: 4,
        sections: [
          PieChartSectionData(value: (ageDist['18-25'] ?? 0).toDouble(), color: Palette.indigoPrimary, title: '18-25', radius: 50, titleStyle: _pieStyle()),
          PieChartSectionData(value: (ageDist['26-35'] ?? 0).toDouble(), color: Palette.cyanGlow, title: '26-35', radius: 50, titleStyle: _pieStyle()),
          PieChartSectionData(value: (ageDist['36-50'] ?? 0).toDouble(), color: Palette.violetAccent, title: '36-50', radius: 50, titleStyle: _pieStyle()),
          PieChartSectionData(value: (ageDist['50+'] ?? 0).toDouble(), color: Palette.bodyGrey, title: '50+', radius: 50, titleStyle: _pieStyle()),
        ],
      ),
    );
  }

  Widget _buildFeedbackList(List feedbacks) {
    return ListView.builder(
      itemCount: feedbacks.length,
      itemBuilder: (context, index) {
        final f = feedbacks[index];
        return Card(
          elevation: 0,
          color: Palette.iceWhite,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Palette.indigoPrimary,
              child: Text("${f['rating']}", style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
            title: Text(f['user'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(f['comment'] ?? "No comment provided"),
          ),
        );
      },
    );
  }

  Widget _buildUserTable(List users) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _boxDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("User Registry", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("NAME")),
                DataColumn(label: Text("EMAIL")),
                DataColumn(label: Text("AGE")),
                DataColumn(label: Text("JOURNALS")),
                DataColumn(label: Text("ACCOUNT CREATED")),
              ],
              rows: users.map((u) {
                
                return DataRow(cells: [
                  DataCell(Text(u['full_name'], style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(u['email'])),
                  DataCell(Text("${u['age']}")),
                  DataCell(Text("${u['journal_count']}")),
                  DataCell(Text(u['created_at']?.toString().split('T')[0] ?? "N/A")),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String val, IconData icon, Color col) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: _boxDeco(),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: col.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: col),
            ),
            const SizedBox(width: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Palette.bodyGrey, fontSize: 12)),
              Text(val, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _contentBox({required String title, required double width, required Widget child}) {
    return Container(
      width: width,
      height: 450,
      padding: const EdgeInsets.all(24),
      decoration: _boxDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("System Overview", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        IconButton(
          onPressed: () => ref.read(adminDashboardProvider.notifier).refresh(),
          icon: const Icon(Icons.refresh_rounded, color: Palette.indigoPrimary),
        ),
      ],
    );
  }

  BoxDecoration _boxDeco() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 5))],
  );

  TextStyle _pieStyle() => const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12);
}

