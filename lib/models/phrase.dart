class Phrase {
  const Phrase({
    required this.id,
    required this.englishTitle,
    required this.japanese,
    required this.romaji,
    required this.english,
    required this.category,
    required this.note,
    required this.createdAt,
  });

  final String id;
  final String englishTitle;
  final String japanese;
  final String romaji;
  final String english;
  final String category;
  final String note;
  final DateTime createdAt;

  factory Phrase.fromJson(Map<String, dynamic> json) => Phrase(
        id: json['id'] as String? ?? '',
        englishTitle: json['englishTitle'] as String? ?? '',
        japanese: json['japanese'] as String? ?? '',
        romaji: json['romaji'] as String? ?? '',
        english: json['english'] as String? ?? '',
        category: json['category'] as String? ?? '',
        note: json['note'] as String? ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'englishTitle': englishTitle,
        'japanese': japanese,
        'romaji': romaji,
        'english': english,
        'category': category,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
      };
}
