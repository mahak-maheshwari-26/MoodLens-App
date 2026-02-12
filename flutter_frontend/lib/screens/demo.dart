import 'package:flutter/material.dart';
import '../theme/app_theme2.dart';


class MoodLensDemo extends StatelessWidget {
  const MoodLensDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("MoodLens Entry")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Example 1: Custom Emotion Gradient Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppGradients.calmGradient,
                // gradient: calmGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(Icons.self_improvement, size: 48, color: Colors.black54),
                  const SizedBox(height: 12),
                  Text(
                    "Keep Calm",
                    style: theme.textTheme.headlineSmall?.copyWith(color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Example 2: Themed Input Field (Uses your central config)
            const TextField(
              decoration: InputDecoration(
                labelText: "What's on your mind?",
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 20),

            // Example 3: Themed Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text("Save Journal Entry"),
            ),
          ],
        ),
      ),
    );
  }
}