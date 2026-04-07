import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kGeminiApiKey = 'gemini_api_key';

class ApiKeyService {
  final FlutterSecureStorage _storage;

  ApiKeyService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  /// APIキーを取得する（未設定の場合はnull）
  Future<String?> getGeminiApiKey() async {
    return await _storage.read(key: _kGeminiApiKey);
  }

  /// APIキーを保存する
  Future<void> saveGeminiApiKey(String apiKey) async {
    await _storage.write(key: _kGeminiApiKey, value: apiKey.trim());
  }

  /// APIキーを削除する
  Future<void> deleteGeminiApiKey() async {
    await _storage.delete(key: _kGeminiApiKey);
  }

  /// APIキーが設定されているか確認する
  Future<bool> hasGeminiApiKey() async {
    final key = await getGeminiApiKey();
    return key != null && key.isNotEmpty;
  }
}

// Riverpodプロバイダー
final apiKeyServiceProvider = Provider<ApiKeyService>((ref) {
  return ApiKeyService();
});

final hasGeminiApiKeyProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(apiKeyServiceProvider);
  return await service.hasGeminiApiKey();
});
