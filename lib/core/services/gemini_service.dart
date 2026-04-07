import 'package:google_generative_ai/google_generative_ai.dart';
import 'api_key_service.dart';

/// Gemini APIを使った画像生成サービス
/// APIキーが未設定の場合は GeminiNotConfiguredException をスローする
class GeminiService {
  final ApiKeyService _apiKeyService;

  GeminiService(this._apiKeyService);

  /// キーワードからぬりえ用の画像プロンプトを生成する
  /// （画像生成自体はImagen APIが必要なため、ここでは説明テキスト生成）
  Future<String> generateColoringDescription(String keyword) async {
    final apiKey = await _apiKeyService.getGeminiApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw GeminiNotConfiguredException();
    }

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );

    final prompt = '''
高齢者向けぬりえの説明文を日本語で作成してください。
テーマ: $keyword
・線画のぬりえとして適した内容の説明
・高齢者が楽しめるシンプルな構成
・50文字以内で簡潔に
説明文のみを出力してください。
''';

    final response = await model.generateContent([Content.text(prompt)]);
    return response.text ?? 'ぬりえの説明を生成できませんでした';
  }

  /// 回想法カード用の問いかけ文を生成する
  Future<List<String>> generateReminiscencePrompts(String theme) async {
    final apiKey = await _apiKeyService.getGeminiApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw GeminiNotConfiguredException();
    }

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );

    final prompt = '''
高齢者向け回想法カードの問いかけ文を5つ作成してください。
テーマ: $theme
・昭和・平成の記憶を引き出す内容
・やさしい日本語
・1つ20文字以内
・番号なしで1行1問いかけで出力
''';

    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text ?? '';
    return text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .take(5)
        .toList();
  }

  /// API接続テスト
  Future<bool> testConnection(String apiKey) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );
      final response =
          await model.generateContent([Content.text('日本語でこんにちはと返してください')]);
      return response.text != null;
    } catch (_) {
      return false;
    }
  }
}

class GeminiNotConfiguredException implements Exception {
  final String message = 'Gemini APIキーが設定されていません';
  @override
  String toString() => message;
}
