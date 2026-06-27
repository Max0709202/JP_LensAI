import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/phrase.dart';

class StorageService {
  static const _savedPhrasesKey = 'saved_phrases';

  Future<void> savePhrase(Phrase phrase) async {
    final prefs = await SharedPreferences.getInstance();
    final phrases = await getSavedPhrases();
    final existingIndex = phrases.indexWhere((item) =>
        item.japanese == phrase.japanese && item.english == phrase.english);

    final updated = [...phrases];
    if (existingIndex >= 0) {
      updated[existingIndex] = phrase;
    } else {
      updated.insert(0, phrase);
    }

    await prefs.setStringList(
      _savedPhrasesKey,
      updated.map((phrase) => jsonEncode(phrase.toJson())).toList(),
    );
  }

  Future<List<Phrase>> getSavedPhrases() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_savedPhrasesKey) ?? [];
    return raw
        .map(
            (item) => Phrase.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  Future<void> deletePhrase(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final phrases = await getSavedPhrases();
    await prefs.setStringList(
      _savedPhrasesKey,
      phrases
          .where((phrase) => phrase.id != id)
          .map((phrase) => jsonEncode(phrase.toJson()))
          .toList(),
    );
  }

  Future<void> clearAllPhrases() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedPhrasesKey);
  }
}
