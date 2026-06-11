import 'dart:math';

import 'package:uuid/uuid.dart';

import '../models/ai_result.dart';
import '../models/menu_item_result.dart';
import 'ai_service.dart';

class MockAiService implements AiService {
  MockAiService({Random? random}) : _random = random ?? Random();

  final Random _random;
  final _uuid = const Uuid();

  @override
  Future<AiResult> analyzeSignImage(String imagePath) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final samples = _signSamples();
    final json = samples[_random.nextInt(samples.length)];
    return AiResult.fromJson({
      'id': _uuid.v4(),
      ...json,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<List<MenuItemResult>> analyzeMenuImage(String imagePath) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final items = _menuSamples()..shuffle(_random);
    return items.take(3 + _random.nextInt(3)).map((json) {
      return MenuItemResult.fromJson({'id': _uuid.v4(), ...json});
    }).toList();
  }

  @override
  Future<String> answerEtiquetteQuestion(String question) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final lower = question.toLowerCase();

    if (lower.contains('tip')) {
      return 'Direct answer: Tipping is usually not expected in Japan.\n\n'
          'Cultural context: Good service is considered part of normal hospitality, and staff may politely refuse extra money.\n\n'
          'What to do: Pay the listed price and say thank you.\n\n'
          'Useful phrase:\nありがとうございます。\nArigatou gozaimasu.\nThank you very much.';
    }
    if (lower.contains('train') || lower.contains('talk')) {
      return 'Direct answer: Keep your voice low on trains and avoid phone calls.\n\n'
          'Cultural context: Trains are shared quiet spaces, especially during commuting hours.\n\n'
          'What to do: Put your phone on silent mode and speak softly if needed.\n\n'
          'Useful phrase:\nすみません。\nSumimasen.\nExcuse me.';
    }
    if (lower.contains('shrine') || lower.contains('temple')) {
      return 'Direct answer: Be calm, respectful, and follow posted rules.\n\n'
          'Cultural context: Shrines and temples are active religious places, not only sightseeing spots.\n\n'
          'What to do: Bow lightly at gates, avoid loud behavior, and do not photograph restricted areas.\n\n'
          'Useful phrase:\n写真を撮ってもいいですか？\nShashin o totte mo ii desu ka?\nMay I take a photo?';
    }
    if (lower.contains('onsen')) {
      return 'Direct answer: Wash before entering the bath, do not wear swimwear, and keep towels out of the water.\n\n'
          'Cultural context: Onsen are shared bathing spaces with careful cleanliness rules.\n\n'
          'What to do: Shower thoroughly first, tie up long hair, and enter quietly.\n\n'
          'Useful phrase:\n使い方を教えてください。\nTsukaikata o oshiete kudasai.\nPlease show me how to use this.';
    }
    if (lower.contains('garbage') || lower.contains('trash')) {
      return 'Direct answer: Public bins are limited, and sorting rules vary by place.\n\n'
          'Cultural context: Japan relies on careful separation of burnable waste, plastics, cans, bottles, and paper.\n\n'
          'What to do: Keep your trash with you until you find the right bin, often near convenience stores or stations.\n\n'
          'Useful phrase:\nゴミ箱はどこですか？\nGomibako wa doko desu ka?\nWhere is the trash bin?';
    }
    if (lower.contains('shoe') || lower.contains('shoes')) {
      return 'Direct answer: Remove shoes when you see entry slippers, tatami rooms, or signs like 土足厳禁.\n\n'
          'Cultural context: Shoes are considered outside items and should not touch clean indoor floors.\n\n'
          'What to do: Leave shoes neatly at the entrance and use slippers if provided.\n\n'
          'Useful phrase:\n靴を脱げばいいですか？\nKutsu o nugeba ii desu ka?\nShould I take off my shoes?';
    }

    return 'Direct answer: When unsure, slow down, watch what local people do, and ask politely.\n\n'
        'Cultural context: Clear, considerate behavior matters more than perfect Japanese.\n\n'
        'What to do: Use simple phrases, avoid blocking paths, and follow signs or staff guidance.\n\n'
        'Useful phrase:\nどうすればいいですか？\nDou sureba ii desu ka?\nWhat should I do?';
  }

  List<Map<String, String>> _signSamples() => [
        {
          'detectedText': '土足厳禁',
          'translation': 'Shoes are strictly prohibited.',
          'explanation':
              'You must take off your shoes before entering this place.',
          'travelerAction':
              'Remove your shoes at the entrance and place them neatly near the door or shoe shelf.',
          'category': 'Etiquette',
          'warningLevel': 'important',
          'phraseJapanese': '靴を脱げばいいですか？',
          'phraseRomaji': 'Kutsu o nugeba ii desu ka?',
          'phraseEnglish': 'Should I take off my shoes?',
        },
        {
          'detectedText': '撮影禁止',
          'translation': 'Photography is prohibited.',
          'explanation':
              'Photos or videos are not allowed in this area, often for privacy, safety, or cultural reasons.',
          'travelerAction': 'Put your camera away and avoid taking photos here.',
          'category': 'Rules',
          'warningLevel': 'important',
          'phraseJapanese': 'ここで写真を撮ってもいいですか？',
          'phraseRomaji': 'Koko de shashin o totte mo ii desu ka?',
          'phraseEnglish': 'May I take photos here?',
        },
        {
          'detectedText': '立入禁止',
          'translation': 'Do not enter.',
          'explanation':
              'This area is restricted. It may be unsafe or reserved for staff.',
          'travelerAction': 'Do not go past this sign. Look for another route.',
          'category': 'Safety',
          'warningLevel': 'important',
          'phraseJapanese': '入ってもいいですか？',
          'phraseRomaji': 'Haitte mo ii desu ka?',
          'phraseEnglish': 'May I enter?',
        },
        {
          'detectedText': '現金のみ',
          'translation': 'Cash only.',
          'explanation':
              'This shop or machine does not accept credit cards or mobile payment.',
          'travelerAction': 'Prepare Japanese yen before ordering or paying.',
          'category': 'Payment',
          'warningLevel': 'caution',
          'phraseJapanese': 'クレジットカードは使えますか？',
          'phraseRomaji': 'Kurejitto kaado wa tsukaemasu ka?',
          'phraseEnglish': 'Can I use a credit card?',
        },
        {
          'detectedText': '本日は休業です',
          'translation': 'Closed today.',
          'explanation':
              'The business is not open today, possibly because of a holiday or irregular closure.',
          'travelerAction': 'Check another branch or return on a different day.',
          'category': 'Business',
          'warningLevel': 'normal',
          'phraseJapanese': '明日は開いていますか？',
          'phraseRomaji': 'Ashita wa aite imasu ka?',
          'phraseEnglish': 'Are you open tomorrow?',
        },
        {
          'detectedText': '人身事故の影響により運転を見合わせています',
          'translation':
              'Train service is suspended due to a passenger accident.',
          'explanation':
              'The train line is temporarily stopped. Delays can be significant.',
          'travelerAction':
              'Ask station staff for an alternate route or wait for service updates.',
          'category': 'Train notice',
          'warningLevel': 'important',
          'phraseJapanese': '別の行き方はありますか？',
          'phraseRomaji': 'Betsu no ikikata wa arimasu ka?',
          'phraseEnglish': 'Is there another way to get there?',
        },
        {
          'detectedText': '飲食禁止',
          'translation': 'No eating or drinking.',
          'explanation':
              'Food and drinks are not allowed in this space to keep it clean or quiet.',
          'travelerAction': 'Finish food or drinks before entering.',
          'category': 'Rules',
          'warningLevel': 'caution',
          'phraseJapanese': 'ここで飲んでもいいですか？',
          'phraseRomaji': 'Koko de nonde mo ii desu ka?',
          'phraseEnglish': 'May I drink here?',
        },
        {
          'detectedText': '予約のお客様のみ',
          'translation': 'Reserved customers only.',
          'explanation':
              'Only people with reservations can enter or be served at this time.',
          'travelerAction': 'Ask if same-day reservations or walk-ins are possible.',
          'category': 'Restaurant',
          'warningLevel': 'normal',
          'phraseJapanese': '予約なしでも入れますか？',
          'phraseRomaji': 'Yoyaku nashi demo hairemasu ka?',
          'phraseEnglish': 'Can I enter without a reservation?',
        },
      ];

  List<Map<String, Object>> _menuSamples() => [
        _menu('Tonkotsu Ramen', '豚骨ラーメン',
            'A rich ramen dish made with pork bone broth.',
            ['pork broth', 'noodles', 'egg', 'green onion', 'soy seasoning'],
            ['wheat', 'egg', 'soy', 'possible sesame'],
            ['pork', 'not vegan'],
            '豚肉は入っていますか？',
            'Does this contain pork?',
            'Butaniku wa haitte imasu ka?'),
        _menu('Sushi Set', '寿司セット',
            'Assorted vinegared rice topped with raw or cooked seafood.',
            ['rice', 'fish', 'shellfish', 'soy sauce', 'wasabi'],
            ['seafood', 'soy', 'possible egg'],
            ['seafood'],
            '生魚が入っていますか？',
            'Does this include raw fish?',
            'Namazakana ga haitte imasu ka?'),
        _menu('Tempura Soba', '天ぷらそば',
            'Buckwheat noodles with fried seafood or vegetables.',
            ['soba noodles', 'shrimp', 'wheat batter', 'dashi broth'],
            ['wheat', 'seafood', 'soy', 'buckwheat'],
            ['seafood', 'wheat'],
            '海老は入っていますか？',
            'Does this contain shrimp?',
            'Ebi wa haitte imasu ka?'),
        _menu('Chicken Yakitori', '焼き鳥',
            'Grilled chicken skewers with salt or sweet soy-based sauce.',
            ['chicken', 'soy sauce', 'sugar', 'mirin'],
            ['soy', 'possible alcohol'],
            ['alcohol'],
            'お酒は使っていますか？',
            'Is alcohol used in this?',
            'Osake wa tsukatte imasu ka?'),
        _menu('Miso Soup', '味噌汁',
            'A warm soup with miso, tofu, seaweed, and dashi.',
            ['miso', 'tofu', 'seaweed', 'dashi'],
            ['soy', 'possible seafood'],
            ['soy', 'seafood', 'vegetarian possible'],
            '出汁に魚は入っていますか？',
            'Does the broth contain fish?',
            'Dashi ni sakana wa haitte imasu ka?'),
        _menu('Curry Rice', 'カレーライス',
            'Japanese curry over rice, usually mild and slightly sweet.',
            ['rice', 'curry roux', 'onion', 'carrot', 'meat'],
            ['wheat', 'dairy possible', 'soy'],
            ['wheat', 'spicy', 'not vegan'],
            '肉は入っていますか？',
            'Does this contain meat?',
            'Niku wa haitte imasu ka?'),
        _menu('Okonomiyaki', 'お好み焼き',
            'Savory pancake with cabbage, batter, sauce, and toppings.',
            ['wheat batter', 'egg', 'cabbage', 'pork', 'seafood flakes'],
            ['wheat', 'egg', 'seafood', 'soy'],
            ['pork', 'seafood', 'not vegan'],
            '豚肉抜きにできますか？',
            'Can you make it without pork?',
            'Butaniku nuki ni dekimasu ka?'),
        _menu('Udon', 'うどん',
            'Thick wheat noodles served hot or cold with broth.',
            ['wheat noodles', 'dashi', 'soy sauce', 'green onion'],
            ['wheat', 'soy', 'possible seafood'],
            ['wheat', 'vegetarian possible'],
            '出汁はベジタリアンですか？',
            'Is the broth vegetarian?',
            'Dashi wa bejitarian desu ka?'),
        _menu('Karaage', '唐揚げ',
            'Japanese fried chicken, usually marinated in soy and ginger.',
            ['chicken', 'soy sauce', 'ginger', 'garlic', 'wheat starch'],
            ['wheat', 'soy', 'egg possible'],
            ['wheat', 'not vegan'],
            '卵は使っていますか？',
            'Do you use egg?',
            'Tamago wa tsukatte imasu ka?'),
      ];

  Map<String, Object> _menu(
    String dishName,
    String japaneseName,
    String description,
    List<String> ingredients,
    List<String> allergyRisks,
    List<String> dietaryTags,
    String usefulPhraseJapanese,
    String usefulPhraseEnglish,
    String usefulPhraseRomaji,
  ) =>
      {
        'dishName': dishName,
        'japaneseName': japaneseName,
        'description': description,
        'ingredients': ingredients,
        'allergyRisks': allergyRisks,
        'dietaryTags': dietaryTags,
        'usefulPhraseJapanese': usefulPhraseJapanese,
        'usefulPhraseEnglish': usefulPhraseEnglish,
        'usefulPhraseRomaji': usefulPhraseRomaji,
      };
}
