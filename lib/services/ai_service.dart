import '../models/ai_result.dart';
import '../models/menu_item_result.dart';

abstract class AiService {
  Future<AiResult> analyzeSignImage(String imagePath);
  Future<List<MenuItemResult>> analyzeMenuImage(String imagePath);
  Future<String> answerEtiquetteQuestion(String question);
}
