import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../provider/admin_provider.dart';
import '../theme/app_theme.dart';

class UserManagementPage extends ConsumerStatefulWidget {
  const UserManagementPage({super.key});

  @override
  ConsumerState<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends ConsumerState<UserManagementPage> {
  String searchQuery = "";
  String ageFilter = "All";
  String sortBy = "Newest Joined";

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(adminDashboardProvider);

    return Scaffold(
      backgroundColor: Palette.iceWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Palette.deepSpace),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("User Management", 
          style: TextStyle(color: Palette.deepSpace, fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Palette.indigoPrimary)),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (data) {
          final allUsers = data['users'] as List;
          final ageDist = data['age_dist'] as Map<String, dynamic>;
          
          // Filtering Logic
          final filteredUsers = allUsers.where((u) {
            final matchesSearch = u['full_name'].toLowerCase().contains(searchQuery.toLowerCase()) || 
                                u['email'].toLowerCase().contains(searchQuery.toLowerCase());
            
            bool matchesAge = true;
            if (ageFilter == "18-25") {
              matchesAge = u['age'] >= 18 && u['age'] <= 25;
            } else if (ageFilter == "26-35") {
              matchesAge = u['age'] >= 26 && u['age'] <= 35;
            } else if (ageFilter == "36+") {
              matchesAge = u['age'] >= 36;
            }
            return matchesSearch && matchesAge;
          }).toList();

          if (sortBy == "Newest Joined") {
            filteredUsers.sort((a, b) => (b['created_at'] ?? "").compareTo(a['created_at'] ?? ""));
          } else if (sortBy == "Oldest Joined") {
            filteredUsers.sort((a, b) => (a['created_at'] ?? "").compareTo(b['created_at'] ?? ""));
          } else if (sortBy == "Most Journals") {
            filteredUsers.sort((a, b) => (b['journal_count'] ?? 0).compareTo(a['journal_count'] ?? 0));
          }

          return Row(
            children: [
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 16, 32),
                  child: Column(
                    children: [
                      _buildFilterBar(),
                      const SizedBox(height: 24),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: _boxDecoration(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SingleChildScrollView(
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(Palette.deepSpace.withValues(alpha: 0.05)),
                                horizontalMargin: 24,
                                columns: _tableColumns(),
                                rows: filteredUsers.map((u) => _buildUserRow(u)).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Right Side: Dynamic Analytics (30% Width)
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 32, 32),
                  child: Column(
                    children: [
                      _buildStatCard(allUsers, filteredUsers),
                      const SizedBox(height: 24),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: _boxDecoration(),
                          child: Column(
                            children: [
                              Text(ageFilter == "All" ? "Age Distribution" : "Filter Impact",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              const Spacer(),
                              SizedBox(
                                height: 250,
                                child: _buildPieChart(ageDist, allUsers.length, filteredUsers.length),
                              ),
                              const Spacer(),
                              _buildLegend(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // UI Components
  Widget _buildFilterBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (val) => setState(() => searchQuery = val),
            decoration: InputDecoration(
              hintText: "Search users...",
              prefixIcon: const Icon(Icons.search, color: Palette.indigoPrimary),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
       _dropdownContainer(
          DropdownButton<String>(
            value: ageFilter,
            underline: const SizedBox(),
            items: ["All", "18-25", "26-35", "36+"].map((v) => DropdownMenuItem(value: v, child: Text("Age: $v"))).toList(),
            onChanged: (val) => setState(() => ageFilter = val!),
          ),
        ),
        const SizedBox(width: 12),
        // Sort Filter
        _dropdownContainer(
          DropdownButton<String>(
            value: sortBy,
            underline: const SizedBox(),
            icon: const Icon(Icons.sort_rounded, color: Palette.indigoPrimary),
            items: ["Newest Joined", "Oldest Joined", "Most Journals"]
                .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (val) => setState(() => sortBy = val!),
          ),
        ),
      ],
    );
  }

  Widget _dropdownContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: child,
    );
  }

  Widget _buildPieChart(Map<String, dynamic> ageDist, int total, int filteredCount) {
    if (ageFilter == "All") {
      // Standard Age Distribution
      return PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: [
            _section(ageDist['18-25'], Palette.indigoPrimary, "18-25"),
            _section(ageDist['26-35'], Palette.cyanGlow, "26-35"),
            _section(ageDist['36-50'], Palette.violetAccent, "36-50"),
            _section(ageDist['50+'], Palette.bodyGrey, "50+"),
          ],
        ),
      );
    } else {
      // Comparison: Selected vs Remaining
      return PieChart(
        PieChartData(
          sectionsSpace: 5,
          centerSpaceRadius: 40,
          sections: [
            PieChartSectionData(
              value: filteredCount.toDouble(),
              color: Palette.cyanGlow,
              title: "${((filteredCount/total)*100).toStringAsFixed(0)}%",
              radius: 60,
              titleStyle: const TextStyle(color: Palette.deepSpace, fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              value: (total - filteredCount).toDouble(),
              color: Palette.deepSpace.withValues(alpha: 0.1),
              title: "",
              radius: 50,
            ),
          ],
        ),
      );
    }
  }

  PieChartSectionData _section(dynamic val, Color color, String title) {
    return PieChartSectionData(
      value: (val ?? 0).toDouble(),
      color: color,
      title: "", // Hidden to keep it clean, legend shows details
      radius: 50,
    );
  }

  Widget _buildLegend() {
    if (ageFilter != "All") {
      return Column(
        children: [
          _legendItem(Palette.cyanGlow, "Selected ($ageFilter)"),
          _legendItem(Palette.deepSpace.withValues(alpha: 0.1), "Others"),
        ],
      );
    }
    return Column(
      children: [
        _legendItem(Palette.indigoPrimary, "18-25"),
        _legendItem(Palette.cyanGlow, "26-35"),
        _legendItem(Palette.violetAccent, "36-50"),
        _legendItem(Palette.bodyGrey, "50+"),
      ],
    );
  }

  Widget _legendItem(Color col, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: col, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Palette.bodyGrey)),
        ],
      ),
    );
  }

  Widget _buildStatCard(List all, List filtered) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Palette.deepSpace, Palette.indigoPrimary]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _quickStat("Total", "${all.length}"),
          Container(width: 1, height: 30, color: Colors.white24),
          _quickStat("Filtered", "${filtered.length}"),
        ],
      ),
    );
  }

  Widget _quickStat(String label, String val) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  List<DataColumn> _tableColumns() => const [
    DataColumn(label: Text("USER", style: TextStyle(fontWeight: FontWeight.bold))),
    DataColumn(label: Text("AGE", style: TextStyle(fontWeight: FontWeight.bold))),
    DataColumn(label: Text("JOURNALS", style: TextStyle(fontWeight: FontWeight.bold))),
    DataColumn(label: Text("JOINED", style: TextStyle(fontWeight: FontWeight.bold))),
  ];

  DataRow _buildUserRow(Map<String, dynamic> u) {
    return DataRow(cells: [
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(u['full_name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Palette.deepSpace)),
          Text(u['email'], style: const TextStyle(fontSize: 11, color: Palette.bodyGrey)),
        ],
      )),
      DataCell(Text("${u['age']}")),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(color: Palette.indigoPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Text("${u['journal_count'] ?? 0}", style: const TextStyle(color: Palette.indigoPrimary, fontWeight: FontWeight.bold)),
      )),
      DataCell(Text(u['created_at'].toString().split('T')[0])),
    ]);
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 5))],
  );
}