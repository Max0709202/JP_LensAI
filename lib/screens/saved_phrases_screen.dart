import 'package:flutter/material.dart';

import '../models/phrase.dart';
import '../services/storage_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/phrase_card.dart';
import 'phrase_detail_screen.dart';

class SavedPhrasesScreen extends StatefulWidget {
  const SavedPhrasesScreen({super.key, required this.storageService});

  final StorageService storageService;

  @override
  State<SavedPhrasesScreen> createState() => _SavedPhrasesScreenState();
}

class _SavedPhrasesScreenState extends State<SavedPhrasesScreen> {
  late Future<List<Phrase>> _phrasesFuture;

  @override
  void initState() {
    super.initState();
    _phrasesFuture = widget.storageService.getSavedPhrases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Phrases')),
      body: FutureBuilder<List<Phrase>>(
        future: _phrasesFuture,
        builder: (context, snapshot) {
          final phrases = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (phrases.isEmpty) {
            return const EmptyState(
              icon: Icons.bookmark_border_rounded,
              title: 'No saved phrases yet.',
              message: 'Save phrases from scan results or emergency phrases.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: phrases.length,
            itemBuilder: (context, index) {
              final phrase = phrases[index];
              return PhraseCard(
                phrase: phrase,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PhraseDetailScreen(
                      phrase: phrase,
                      storageService: widget.storageService,
                    ),
                  ),
                ),
                onDelete: () => _delete(phrase.id),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _delete(String id) async {
    await widget.storageService.deletePhrase(id);
    setState(() {
      _phrasesFuture = widget.storageService.getSavedPhrases();
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Phrase deleted.')));
  }
}
