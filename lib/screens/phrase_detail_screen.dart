import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../models/phrase.dart';
import '../services/storage_service.dart';
import '../widgets/app_primary_button.dart';
import '../widgets/result_section_card.dart';

class PhraseDetailScreen extends StatelessWidget {
  const PhraseDetailScreen({
    super.key,
    required this.phrase,
    required this.storageService,
  });

  final Phrase phrase;
  final StorageService storageService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(phrase.englishTitle)),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            phrase.japanese,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            phrase.romaji,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 18),
          ResultSectionCard(
            title: 'English Meaning',
            child: Text(phrase.english),
          ),
          ResultSectionCard(
            title: 'Situation Note',
            child: Text(phrase.note),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppPrimaryButton(
                label: 'Copy',
                icon: Icons.copy_rounded,
                onPressed: () => _copy(context),
              ),
              AppPrimaryButton(
                label: 'Save Phrase',
                icon: Icons.bookmark_add_rounded,
                secondary: true,
                onPressed: () => _save(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(
          text: '${phrase.japanese}\n${phrase.romaji}\n${phrase.english}'),
    );
    if (context.mounted) _snack(context, 'Phrase copied.');
  }

  Future<void> _save(BuildContext context) async {
    await storageService.savePhrase(
      Phrase(
        id: const Uuid().v4(),
        englishTitle: phrase.englishTitle,
        japanese: phrase.japanese,
        romaji: phrase.romaji,
        english: phrase.english,
        category: phrase.category,
        note: phrase.note,
        createdAt: DateTime.now(),
      ),
    );
    if (context.mounted) _snack(context, 'Phrase saved.');
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
