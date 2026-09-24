import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';

class GrowSaathiApp extends StatelessWidget {
  const GrowSaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GrowSAATHI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
