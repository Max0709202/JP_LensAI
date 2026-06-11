class AiResult {
  const AiResult({
    required this.id,
    required this.detectedText,
    required this.translation,
    required this.explanation,
    required this.travelerAction,
    required this.category,
    required this.warningLevel,
    required this.phraseJapanese,
    required this.phraseRomaji,
    required this.phraseEnglish,
    required this.createdAt,
  });

  final String id;
  final String detectedText;
  final String translation;
  final String explanation;
  final String travelerAction;
  final String category;
  final String warningLevel;
  final String phraseJapanese;
  final String phraseRomaji;
  final String phraseEnglish;
  final DateTime createdAt;

  factory AiResult.fromJson(Map<String, dynamic> json) => AiResult(
        id: json['id'] as String? ?? '',
        detectedText: json['detectedText'] as String? ?? '',
        translation: json['translation'] as String? ?? '',
        explanation: json['explanation'] as String? ?? '',
        travelerAction: json['travelerAction'] as String? ?? '',
        category: json['category'] as String? ?? '',
        warningLevel: json['warningLevel'] as String? ?? 'normal',
        phraseJapanese: json['phraseJapanese'] as String? ?? '',
        phraseRomaji: json['phraseRomaji'] as String? ?? '',
        phraseEnglish: json['phraseEnglish'] as String? ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'detectedText': detectedText,
        'translation': translation,
        'explanation': explanation,
        'travelerAction': travelerAction,
        'category': category,
        'warningLevel': warningLevel,
        'phraseJapanese': phraseJapanese,
        'phraseRomaji': phraseRomaji,
        'phraseEnglish': phraseEnglish,
        'createdAt': createdAt.toIso8601String(),
      };
}
