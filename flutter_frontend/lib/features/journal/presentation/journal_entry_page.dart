import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/journal/providers/journal_provider.dart';
import 'package:flutter_frontend/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JournalEntryPage1 extends ConsumerStatefulWidget{
  const JournalEntryPage1({super.key});

  @override
  ConsumerState<JournalEntryPage1> createState() => _JournalEntryPageState1();
}

class _JournalEntryPageState1 extends ConsumerState<JournalEntryPage1>{

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final List<String> _quickPrompts = [
    "Today was productive!",
    "It was stressful",
    "Sleepy but happy.",
    "Ate something very tasty and delicious",
    "Had an amazing day.",
    "Overcame a major roadblock, now I can finally achieve my goal."
  ];

  void _onSave() async{
    if (_titleController.text.isEmpty || _contentController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add a title and some content!"),
        backgroundColor: Palette.medGrey,),
      );
      return;
    }

    // Call notifier
    await ref.read(journalProvider.notifier).createEntry(
      _titleController.text,
      _contentController.text);

    // if (mounted){
    //   Navigator.pop(context);
    // }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final journalState = ref.watch(journalProvider);

    return Scaffold(
      backgroundColor: Palette.iceWhite,
      appBar: AppBar(
        title: const Text(
          "Reflect", 
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 5,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Palette.slateHeading),
                    decoration: const InputDecoration(
                      hintText: "Entry Title",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 10,),

                  // Prompt chips
                  const Text("Quick Start: ", style: TextStyle(color: Palette.bodyGrey, fontWeight: FontWeight.w600),),
                  const SizedBox(height: 10,),

                  SizedBox(
                    height: 40,
                    child : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _quickPrompts.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            label: Text(_quickPrompts[index]),
                            backgroundColor: index % 2 == 0 ? Palette.cardIndigoTint : Palette.cardTealTint,
                            labelStyle: TextStyle(color: Palette.indigoPrimary, fontSize: 13),
                            side: BorderSide.none,
                            onPressed: () {
                              setState(() {
                                _contentController.text += "${_quickPrompts[index]} ";
                              },);
                            },
                            ),
                          );
                      }
                      ),
                  ),
                  const SizedBox(height: 20),

                  // Content input
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Palette.surfaceGlass,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha : 0.05),
                          blurRadius : 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _contentController,
                      maxLines: 12,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Palette.bodyGrey
                      ),
                      decoration: const InputDecoration(
                        hintText: "How's your heart feeling today?",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none, 
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            // Save Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: journalState.maybeWhen(
                  loading: () => const CircularProgressIndicator(color: Palette.indigoPrimary),
                  orElse: () => Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppGradients.electricAurora,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Palette.indigoPrimary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0,6),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(18)),
                      ), 
                      child: const Text(
                        "Save and Analyze Mood",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight:FontWeight.bold
                        ),
                      )
                      ),
                  )
                ),
                ),
            )
          ],
        ),
        ),
    );

  }

}