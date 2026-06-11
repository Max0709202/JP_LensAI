import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../services/storage_service.dart';
import '../widgets/result_section_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.storageService});

  final StorageService storageService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const ResultSectionCard(
            title: 'App',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SettingLine(label: 'Name', value: AppConstants.appName),
                _SettingLine(label: 'Version', value: AppConstants.version),
                _SettingLine(label: 'Language', value: 'English'),
                _SettingLine(label: 'AI mode', value: AppConstants.mockModeLabel),
                _SettingLine(
                  label: 'Backend',
                  value: 'Future API endpoint placeholder',
                ),
              ],
            ),
          ),
          const ResultSectionCard(
            title: 'Privacy',
            child: Text(
              'This MVP uses local mock responses. Future versions may send images or text to an AI backend for analysis.',
            ),
          ),
          ResultSectionCard(
            title: 'Saved Data',
            child: Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () => _clear(context),
                icon: const Icon(Icons.delete_sweep_rounded),
                label: const Text('Clear saved phrases'),
              ),
            ),
          ),
          const ResultSectionCard(
            title: 'Future iOS Support',
            child: Text(
              'Future release work includes Xcode setup, Apple Developer signing, bundle identifier, Info.plist camera/photo permissions, App Store Connect, TestFlight, and iOS payment/subscription setup.',
            ),
          ),
          const ResultSectionCard(
            title: 'Future Premium Plan',
            child: Text(
              'Future versions may include premium AI scans, offline phrase packs, multilingual support, and partner travel features.',
            ),
          ),
          const ResultSectionCard(
            title: 'Future Integrations',
            child: Text(
              'Planned integrations include OCR, a vision model, an LLM backend, account support, cloud storage, offline phrase packs, notifications, analytics, and crash reporting.',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clear(BuildContext context) async {
    await storageService.clearAllPhrases();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved phrases cleared.')));
  }
}

class _SettingLine extends StatelessWidget {
  const _SettingLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
