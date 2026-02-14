import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/journal/models/journal_model.dart';
import 'package:flutter_frontend/features/journal/providers/journal_provider.dart';
import 'package:flutter_frontend/features/journal/services/journal_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';

class JournalDetailsModal extends ConsumerStatefulWidget {
  final JournalEntry entry;
  const JournalDetailsModal({super.key, required this.entry});

  @override
  ConsumerState<JournalDetailsModal> createState() => _JournalDetailsModalState();
}

class _JournalDetailsModalState extends ConsumerState<JournalDetailsModal> {
  late TextEditingController _controller;
  bool isEditing = false;
  bool isLoading = true;
  String? fullContent;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadFullEntry();
  }

  Future<void> _loadFullEntry() async {
    try {
      final fullEntry = await ref.read(journalServiceProvider).fetchJournalById(widget.entry.id);
      if (mounted) {
        setState(() {
          fullContent = fullEntry.content;
          _controller.text = fullEntry.content ?? "";
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.expand_more)),
              Text(isEditing ? "Edit Reflection" : "Your Reflection", 
                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 40), 
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isLoading
            ? const Center(child: CircularProgressIndicator())
            
            : isEditing 
              ? TextField(
                  controller: _controller,
                  maxLines: null,
                  style: const TextStyle(fontSize: 16, color: Palette.slateHeading),
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Update your thoughts..."),
                )
              : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(_controller.text.isEmpty ? "No content available." : _controller.text,
                    style: const TextStyle(fontSize: 18, height: 1.6, color: Palette.slateHeading,fontWeight: FontWeight.w500))),
                ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isEditing ? Colors.green : Palette.indigoPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
              onPressed: () async {
                if (isEditing) {
                  final navigator = Navigator.of(context);

                  await ref.read(journalProvider.notifier).updateEntry(
                      widget.entry.id,
                      _controller.text
                      );

                  if (!context.mounted) return;
                  navigator.pop();
                  
                } else {
                  setState(() => isEditing = true);
                }
              },
              child: Text(isEditing ? "Save Changes" : "Update Reflection", style: const TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}