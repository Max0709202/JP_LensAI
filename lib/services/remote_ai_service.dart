import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../models/ai_result.dart';
import '../models/menu_item_result.dart';
import 'ai_service.dart';

class RemoteAiService implements AiService {
  RemoteAiService({http.Client? client}) : _client = client ?? http.Client();

  // TODO: Future production integrations:
  // Firebase Auth, Supabase database, Stripe or RevenueCat payments,
  // offline phrase packs, multilingual support, push notifications,
  // analytics, crash reporting, and iOS release configuration.
  final http.Client _client;
  final _uuid = const Uuid();
  final String _baseUrl = AppConstants.apiBaseUrl;

  @override
  Future<AiResult> analyzeSignImage(String imagePath) async {
    // TODO: Integrate OCR or a vision model here.
    // Future flow: mobile app -> image/OCR text -> backend API ->
    // OCR/Vision AI -> LLM structured JSON -> app result UI.
    final response = await _post('/api/analyze-sign', {'imagePath': imagePath});
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return AiResult.fromJson({
      'id': _uuid.v4(),
      ...data,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<List<MenuItemResult>> analyzeMenuImage(String imagePath) async {
    // TODO: Replace imagePath placeholder with multipart image upload or OCR text.
    final response = await _post('/api/analyze-menu', {'imagePath': imagePath});
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) {
      final json = item as Map<String, dynamic>;
      return MenuItemResult.fromJson({'id': _uuid.v4(), ...json});
    }).toList();
  }

  @override
  Future<String> answerEtiquetteQuestion(String question) async {
    // TODO: Add Firebase Auth or Supabase session metadata when accounts exist.
    final response = await _post('/api/etiquette-answer', {
      'question': question,
    });
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['answer'] as String? ?? '';
  }

  Future<http.Response> _post(String path, Map<String, Object?> body) {
    if (_baseUrl.isEmpty) {
      throw StateError('API_BASE_URL is not configured.');
    }
    return _client.post(
      Uri.parse('$_baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }
}
