import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

/// Global "Ask GrowSAATHI" floating button, per the brief's navigation
/// spec. Opens the offline chat screen (Module 4).
class FloatingChatButton extends StatelessWidget {
  const FloatingChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.purple,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.smart_toy_outlined),
      label: const Text('Ask GrowSAATHI'),
      onPressed: () => context.push('/chat'),
    );
  }
}
