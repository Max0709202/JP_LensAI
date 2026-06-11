import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/mock_ai_service.dart';
import 'services/storage_service.dart';

class JapanLensAiApp extends StatelessWidget {
  const JapanLensAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final aiService = MockAiService();
    final storageService = StorageService();

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: HomeScreen(aiService: aiService, storageService: storageService),
    );
  }
}
