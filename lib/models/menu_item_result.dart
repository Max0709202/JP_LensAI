class MenuItemResult {
  const MenuItemResult({
    required this.id,
    required this.dishName,
    required this.japaneseName,
    required this.description,
    required this.ingredients,
    required this.allergyRisks,
    required this.dietaryTags,
    required this.usefulPhraseJapanese,
    required this.usefulPhraseEnglish,
    required this.usefulPhraseRomaji,
  });

  final String id;
  final String dishName;
  final String japaneseName;
  final String description;
  final List<String> ingredients;
  final List<String> allergyRisks;
  final List<String> dietaryTags;
  final String usefulPhraseJapanese;
  final String usefulPhraseEnglish;
  final String usefulPhraseRomaji;

  factory MenuItemResult.fromJson(Map<String, dynamic> json) => MenuItemResult(
        id: json['id'] as String? ?? '',
        dishName: json['dishName'] as String? ?? '',
        japaneseName: json['japaneseName'] as String? ?? '',
        description: json['description'] as String? ?? '',
        ingredients: _stringList(json['ingredients']),
        allergyRisks: _stringList(json['allergyRisks']),
        dietaryTags: _stringList(json['dietaryTags']),
        usefulPhraseJapanese: json['usefulPhraseJapanese'] as String? ?? '',
        usefulPhraseEnglish: json['usefulPhraseEnglish'] as String? ?? '',
        usefulPhraseRomaji: json['usefulPhraseRomaji'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
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

  static List<String> _stringList(Object? value) =>
      value is List ? value.map((item) => item.toString()).toList() : [];
}
