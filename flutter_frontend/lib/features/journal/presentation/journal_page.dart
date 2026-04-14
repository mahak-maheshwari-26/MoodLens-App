import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_theme.dart';
import '../providers/journal_provider.dart';


class JournalEntryPage extends ConsumerStatefulWidget {
  const JournalEntryPage({super.key});

  @override
  ConsumerState<JournalEntryPage> createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends ConsumerState<JournalEntryPage> {
  final PageController _pageController = PageController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  int _currentPage = 0;


final List<Map<String, dynamic>> _storyStarters = [
    {
      "text": "I'm celebrating a small win today and feeling really good about my progress.",
      "color": Palette.cardTealTint,
      "icon": Icons.wb_sunny_outlined,
    },
    {
      "text": "Everything seems to be falling into place lately, and I'm enjoying this positive energy.",
      "color": Palette.cardPinkTint,
      "icon": Icons.sentiment_very_satisfied,
    },
    {
      "text": "I'm feeling a bit disconnected today and struggling to find my usual motivation.",
      "color": Palette.cardGreyTint,
      "icon": Icons.cloud_outlined,
    },
    {
      "text": "Things feel quite heavy right now, and I'm finding it difficult to stay upbeat.",
      "color": Palette.cardBrownTint,
      "icon": Icons.hourglass_empty,
    },
    {
      "text": "I'm feeling quite bothered by a situation that didn't feel fair or right to me.",
      "color": Palette.cardIndigoTint, 
      "icon": Icons.bolt,
    },
    {
      "text": "There is a lot of frustration building up today because things are not going as expected.",
      "color": Palette.cardOrangeTint,
      "icon": Icons.priority_high,
    },
  ];

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _saveJournal() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add some content to your reflection!"),
        backgroundColor: Palette.medGrey,),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final journalNotifier = ref.read(journalProvider.notifier);

    final String autoTitle = "Reflection : ${DateFormat('EEEE, MMM d').format(DateTime.now())}";

  try {
    await journalNotifier.createEntry(
      _titleController.text.isEmpty ? autoTitle : _titleController.text.trim(),
      _contentController.text.trim(),
    );
    if (mounted) {
      Navigator.of(context).pop(); 
      ref.invalidate(recentJournalsProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reflection saved successfully!"),
          backgroundColor: Palette.indigoPrimary,
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving: $e"), backgroundColor: Palette.error),
      );
    }
   }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.etherealBackground),
        child: SafeArea(
          child: Column(
            children: [
            _buildHeader(),
            
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildStep1(), // Choice Step
                  _buildStep2(), // Writing Step
                ],
              ),
            ),
          ],
        ),
      ),
              ),
    );
  }



  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (_currentPage == 0){
                    Navigator.pop(context); 
                  } else{
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                icon: Icon(
                  _currentPage == 0 ? Icons.close : Icons.arrow_back_ios_new,
                  color: Palette.slateHeading,
                  size: 20,
                ),
              ),
              Text("${_currentPage + 1} of 2", style: const TextStyle(fontWeight: FontWeight.bold, color: Palette.indigoPrimary)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / 2,
              minHeight: 8,
              backgroundColor: Palette.lightGrey,
              valueColor: const AlwaysStoppedAnimation<Color>(Palette.indigoPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("What's on your mind?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Palette.slateHeading)),
          const SizedBox(height: 8),
          const Text("Pick a starter or skip to writing.", style: TextStyle(color: Palette.bodyGrey)),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: _storyStarters.length,
              itemBuilder: (context, index) {
                final item = _storyStarters[index];
                return GestureDetector(
                  onTap: () {
                    _contentController.text = item['text'];
                    _nextPage();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: item['color'],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Palette.indigoPrimary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(item['icon'], size: 25, color: Palette.indigoPrimary),
                        const SizedBox(width: 15),
                        Expanded(child: Text(item['text'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Palette.indigoPrimary))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Center(child: TextButton(onPressed: _nextPage, child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("I'll start from scratch", style: TextStyle(color: Palette.bodyGrey, fontSize: 18)),
              const Icon(Icons.arrow_forward, color: Palette.bodyGrey,),

            ],
          )))
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(hintText: "Title your reflection...", border: InputBorder.none),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .6), borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: _contentController,
                keyboardAppearance: Brightness.light,
                keyboardType: TextInputType.text,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(hintText: "Flow with your thoughts...", border: InputBorder.none),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _saveJournal,
              style: ElevatedButton.styleFrom(backgroundColor: Palette.indigoPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: ref.watch(journalProvider).isLoading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text("Analyze & Save", style: TextStyle(color: Colors.white, fontSize: 18)),            
                ),
          )
        ],
      ),
    );
  }
}