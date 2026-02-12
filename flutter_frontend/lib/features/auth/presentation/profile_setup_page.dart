import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/theme/app_theme.dart';
import 'package:flutter_frontend/core/widgets/auth_widgets.dart';

class ProfileSetupPage extends ConsumerStatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  ConsumerState<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends ConsumerState<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: Palette.indigoPrimary,
              headerForegroundColor: Colors.white,
              backgroundColor: Palette.iceWhite,
              dayBackgroundColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Palette.indigoPrimary;
                }
                if (states.contains(WidgetState.hovered)) {
                  return Palette.indigoPrimary.withValues(alpha: 0.1);
                }
                return Colors.transparent;
              }),
              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: Palette.indigoPrimary,
              ),
              confirmButtonStyle: TextButton.styleFrom(
                foregroundColor: Palette.indigoPrimary,
              ),
            ),
          ),
          child: child!
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveProfile() async{
    if (_formKey.currentState!.validate() && _selectedDate != null) {

      final name = _nameController.text.trim();
      if (name.isEmpty) return;

      await ref.read(authProvider.notifier).updateProfile(
        name: name,
        birthdate: _selectedDate,
        );
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select your birth date")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false, 
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.etherealBackground,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    /*
                    LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor: Palette.indigoPrimary.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(Palette.indigoPrimary),
                      controller: AnimationController(
                        vsync: TickerProvider.
                        ),
                    )
                    ,*/

                    // 1. NEON PROGRESS INDICATOR (Step 1 of 2)
                    _buildProgressBar(0.5), 
                    const SizedBox(height: 40),

                    // 2. WELCOME TEXT
                    Text(
                      "Tell us about yourself",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Palette.indigoPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Help us personalize your MoodLens experience.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Palette.deepSpace.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 3. PROFILE FORM (Inside a Glass Card style)
                    AuthTextField(
                      controller: _nameController,
                      label: "Full Name",
                      icon: Icons.person_outline_rounded,
                      validator: (value) => value!.isEmpty ? "Name is required" : null,
                    ),
                    const SizedBox(height: 20),

                    // DATE PICKER FIELD
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Palette.iceWhite.withValues(alpha: 1),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Palette.medGrey.withValues(alpha: 1)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.cake_outlined, color: Palette.indigoPrimary),
                            const SizedBox(width: 12),
                            Text(
                              _selectedDate == null 
                                ? "Birth Date" 
                                : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                              style: TextStyle(
                                color: Palette.deepSpace,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.calendar_today, size: 18, color: Palette.medGrey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 4. ACTION BUTTON
                    AuthButton(
                      text: "Continue",
                      onPressed: _saveProfile,
                    ),
                    
                    // Manual spacer for keyboard
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom * 0.85),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      width: 200,
      height: 6,
      decoration: BoxDecoration(
        color: Palette.indigoPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.premiumText,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Palette.violetAccent.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}