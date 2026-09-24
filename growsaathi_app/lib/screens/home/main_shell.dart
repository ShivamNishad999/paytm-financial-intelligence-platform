import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/common/floating_chat_button.dart';

/// Bottom-nav shell shared by the 5 main tabs (Home, Insights, Actions,
/// Campaigns, More), with the global "Ask GrowSAATHI" floating button
/// per the brief's navigation spec. Wired via go_router's StatefulShellRoute
/// so each tab keeps its own navigation stack.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.insights_rounded, label: 'Insights'),
    (icon: Icons.task_alt_rounded, label: 'Actions'),
    (icon: Icons.campaign_rounded, label: 'Campaigns'),
    (icon: Icons.more_horiz_rounded, label: 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: const FloatingChatButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: [
          for (final tab in _tabs)
            BottomNavigationBarItem(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }
}
