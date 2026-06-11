import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';
import '../widgets/feature_card.dart';
import 'emergency_phrases_screen.dart';
import 'etiquette_chat_screen.dart';
import 'menu_helper_screen.dart';
import 'saved_phrases_screen.dart';
import 'scan_sign_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.aiService,
    required this.storageService,
  });

  final AiService aiService;
  final StorageService storageService;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
          children: [
            Text(
              AppConstants.appName,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              AppConstants.tagline,
              style: textTheme.titleMedium?.copyWith(color: colors.primary),
            ),
            const SizedBox(height: 12),
            Text(AppConstants.valueProposition, style: textTheme.bodyLarge),
            const SizedBox(height: 22),
            FeatureCard(
              icon: Icons.camera_alt_rounded,
              title: 'Scan Japanese Sign',
              description: 'Understand signs, notices, and rules around Japan.',
              onTap: () => _push(
                context,
                ScanSignScreen(
                  aiService: aiService,
                  storageService: storageService,
                ),
              ),
            ),
            FeatureCard(
              icon: Icons.restaurant_menu_rounded,
              title: 'Menu Helper',
              description:
                  'Check ingredients, allergy risks, and dietary concerns.',
              onTap: () => _push(
                context,
                MenuHelperScreen(
                  aiService: aiService,
                  storageService: storageService,
                ),
              ),
            ),
            FeatureCard(
              icon: Icons.local_hospital_rounded,
              title: 'Emergency Phrases',
              description:
                  'Show important Japanese phrases when you need help.',
              onTap: () => _push(
                context,
                EmergencyPhrasesScreen(storageService: storageService),
              ),
            ),
            FeatureCard(
              icon: Icons.forum_rounded,
              title: 'Etiquette Q&A',
              description:
                  'Ask about manners, trains, restaurants, shrines, onsen, and more.',
              onTap: () => _push(
                context,
                EtiquetteChatScreen(aiService: aiService),
              ),
            ),
            FeatureCard(
              icon: Icons.bookmark_rounded,
              title: 'Saved Phrases',
              description: 'Keep useful phrases for quick access.',
              onTap: () => _push(
                context,
                SavedPhrasesScreen(storageService: storageService),
              ),
            ),
            FeatureCard(
              icon: Icons.settings_rounded,
              title: 'Settings',
              description: 'Manage app information, mode, and saved data.',
              onTap: () => _push(
                context,
                SettingsScreen(storageService: storageService),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}
