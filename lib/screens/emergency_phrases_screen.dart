import 'package:flutter/material.dart';

import '../models/phrase.dart';
import '../services/storage_service.dart';
import '../widgets/phrase_card.dart';
import 'phrase_detail_screen.dart';

class EmergencyPhrasesScreen extends StatelessWidget {
  const EmergencyPhrasesScreen({super.key, required this.storageService});

  final StorageService storageService;

  static final phrases = <Phrase>[
    _phrase('I need a hospital', '病院に行きたいです。', 'Byouin ni ikitai desu.',
        'I want to go to a hospital.'),
    _phrase('I lost my passport', 'パスポートをなくしました。',
        'Pasupooto o nakushimashita.', 'I lost my passport.'),
    _phrase('I am lost', '道に迷いました。', 'Michi ni mayoimashita.', 'I am lost.'),
    _phrase('I have an allergy', 'アレルギーがあります。', 'Arerugii ga arimasu.',
        'I have an allergy.'),
    _phrase('Please call the police', '警察を呼んでください。',
        'Keisatsu o yonde kudasai.', 'Please call the police.'),
    _phrase('I missed the last train', '終電を逃しました。', 'Shuuden o nogashimashita.',
        'I missed the last train.'),
    _phrase('Please write it down', '書いてください。', 'Kaite kudasai.',
        'Please write it down.'),
    _phrase('I do not understand', 'わかりません。', 'Wakarimasen.',
        'I do not understand.'),
    _phrase('Please call my hotel', 'ホテルに電話してください。',
        'Hoteru ni denwa shite kudasai.', 'Please call my hotel.'),
    _phrase('Can you help me?', '助けてもらえますか？', 'Tasukete moraemasu ka?',
        'Can you help me?'),
    _phrase('I need a taxi', 'タクシーが必要です。', 'Takushii ga hitsuyou desu.',
        'I need a taxi.'),
    _phrase('I lost my wallet', '財布をなくしました。', 'Saifu o nakushimashita.',
        'I lost my wallet.'),
    _phrase(
        'I need an English speaker',
        '英語を話せる人が必要です。',
        'Eigo o hanaseru hito ga hitsuyou desu.',
        'I need someone who speaks English.'),
    _phrase('Please speak slowly', 'ゆっくり話してください。', 'Yukkuri hanashite kudasai.',
        'Please speak slowly.'),
  ];

  static Phrase _phrase(
    String title,
    String japanese,
    String romaji,
    String english,
  ) =>
      Phrase(
        id: title,
        englishTitle: title,
        japanese: japanese,
        romaji: romaji,
        english: english,
        category: 'Emergency',
        note:
            'Show this phrase to station staff, hotel staff, taxi drivers, or nearby shop staff.',
        createdAt: DateTime.now(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Phrases')),
      body: ListView.builder(
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
                  storageService: storageService,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
