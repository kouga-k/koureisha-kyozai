import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_key_service.dart';
import '../../core/services/gemini_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _controller = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  String? _statusMessage;
  bool _statusIsError = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentKey();
  }

  Future<void> _loadCurrentKey() async {
    final service = ref.read(apiKeyServiceProvider);
    final key = await service.getGeminiApiKey();
    if (key != null && key.isNotEmpty) {
      _controller.text = key;
    }
  }

  Future<void> _saveKey() async {
    final apiKey = _controller.text.trim();
    if (apiKey.isEmpty) {
      setState(() {
        _statusMessage = 'APIキーを入力してください';
        _statusIsError = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'APIキーを確認中...';
      _statusIsError = false;
    });

    // 接続テスト
    final service = ref.read(apiKeyServiceProvider);
    final gemini = GeminiService(service);
    final ok = await gemini.testConnection(apiKey);

    if (!mounted) return;

    if (ok) {
      await service.saveGeminiApiKey(apiKey);
      ref.invalidate(hasGeminiApiKeyProvider);
      setState(() {
        _isLoading = false;
        _statusMessage = '✓ APIキーを保存しました。AI機能が使えます。';
        _statusIsError = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _statusMessage = 'APIキーが正しくないか、接続できませんでした。\n確認してもう一度お試しください。';
        _statusIsError = true;
      });
    }
  }

  Future<void> _deleteKey() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('APIキーを削除'),
        content: const Text('Gemini APIキーを削除しますか？\nAI機能が使えなくなります。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('削除する'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(apiKeyServiceProvider);
      await service.deleteGeminiApiKey();
      ref.invalidate(hasGeminiApiKeyProvider);
      _controller.clear();
      if (!mounted) return;
      setState(() {
        _statusMessage = 'APIキーを削除しました';
        _statusIsError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gemini API セクション
              const Text(
                'Gemini APIキー（AI画像生成用）',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AIを使った画像生成・回想法カードの問いかけ自動作成に使います。\n設定しなくても基本機能はすべて無料で使えます。',
                      style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'APIキーはGoogle AI Studioで無料取得できます。',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // APIキー入力フィールド
              TextField(
                controller: _controller,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Gemini APIキー',
                  hintText: 'AIza...',
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscure = !_obscure),
                    tooltip: _obscure ? '表示' : '非表示',
                  ),
                  border: const OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16),

              // ステータスメッセージ
              if (_statusMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _statusIsError
                        ? AppColors.danger.withOpacity(0.1)
                        : AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _statusIsError ? AppColors.danger : AppColors.accent,
                    ),
                  ),
                  child: Text(
                    _statusMessage!,
                    style: TextStyle(
                      fontSize: 14,
                      color: _statusIsError ? AppColors.danger : AppColors.accent,
                    ),
                  ),
                ),
              if (_statusMessage != null) const SizedBox(height: 16),

              // 保存ボタン
              ElevatedButton.icon(
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? '確認中...' : 'APIキーを保存する'),
                onPressed: _isLoading ? null : _saveKey,
              ),
              const SizedBox(height: 12),

              // 削除ボタン
              OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                label: const Text(
                  'APIキーを削除する',
                  style: TextStyle(color: AppColors.danger),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.danger),
                ),
                onPressed: _deleteKey,
              ),

              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 16),

              // アプリ情報
              const Text(
                'このアプリについて',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'バージョン 1.0.0\n高齢者向け教材生成アプリ',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
