import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_key_service.dart';
import 'ai_coloring_service.dart';

class AiColoringScreen extends ConsumerStatefulWidget {
  /// テンプレートから開く場合はテーマを渡す。オリジナル作成はnull。
  final String? initialTheme;

  const AiColoringScreen({super.key, this.initialTheme});

  @override
  ConsumerState<AiColoringScreen> createState() => _AiColoringScreenState();
}

class _AiColoringScreenState extends ConsumerState<AiColoringScreen> {
  late final TextEditingController _themeCtrl;
  Uint8List? _pngBytes;
  bool _isGenerating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _themeCtrl = TextEditingController(text: widget.initialTheme ?? '');
  }

  @override
  void dispose() {
    _themeCtrl.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final theme = _themeCtrl.text.trim();
    if (theme.isEmpty) {
      setState(() => _errorMessage = '\u30c6\u30fc\u30de\u3092\u5165\u529b\u3057\u3066\u304f\u3060\u3055\u3044');
      return;
    }

    final apiKey = await ref.read(apiKeyServiceProvider).getGeminiApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      setState(() {
        _errorMessage =
            'Gemini API\u30ad\u30fc\u304c\u8a2d\u5b9a\u3055\u308c\u3066\u3044\u307e\u305b\u3093\u3002\n'
            '\u8a2d\u5b9a\u753b\u9762\u304b\u3089API\u30ad\u30fc\u3092\u767b\u9332\u3057\u3066\u304f\u3060\u3055\u3044\u3002';
      });
      return;
    }

    setState(() {
      _isGenerating = true;
      _errorMessage = null;
      _pngBytes = null;
    });

    try {
      final svg = await AiColoringService.generateSvg(theme, apiKey);
      if (svg == null || svg.isEmpty) {
        throw Exception('\u30c7\u30b6\u30a4\u30f3\u306e\u751f\u6210\u306b\u5931\u6557\u3057\u307e\u3057\u305f\u3002\u3082\u3046\u4e00\u5ea6\u304a\u8a66\u3057\u304f\u3060\u3055\u3044\u3002');
      }
      final png = await AiColoringService.svgToPng(svg);
      if (mounted) setState(() => _pngBytes = png);
    } catch (e) {
      if (mounted) setState(() => _errorMessage = '\u30a8\u30e9\u30fc\u304c\u767a\u751f\u3057\u307e\u3057\u305f:\n$e');
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _savePdf() async {
    if (_pngBytes == null) return;
    try {
      await AiColoringService.saveToPdf(
        _pngBytes!,
        '${_themeCtrl.text.trim()}\u306c\u308a\u3048',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF\u4fdd\u5b58\u30a8\u30e9\u30fc: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTemplate = widget.initialTheme != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isTemplate
            ? '${widget.initialTheme}\u306e\u306c\u308a\u3048\u3092\u4f5c\u308b'
            : 'AI\u3067\u30aa\u30ea\u30b8\u30ca\u30eb\u306c\u308a\u3048\u3092\u4f5c\u308b'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 説明バナー
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.teal, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isTemplate
                            ? 'AI\u304c\u300c${widget.initialTheme}\u300d\u306e\u30d7\u30ed\u54c1\u8cea\u306a\u8f2a\u90ed\u7dda\u753b\u3092\u751f\u6210\u3057\u307e\u3059\u3002\nGemini API\u30ad\u30fc\u304c\u5fc5\u8981\u3067\u3059\u3002'
                            : 'AI\u304c\u30c6\u30fc\u30de\u306b\u5408\u308f\u305b\u305f\u30d7\u30ed\u54c1\u8cea\u306a\u306c\u308a\u3048\u3092\u81ea\u52d5\u751f\u6210\u3057\u307e\u3059\u3002\nGemini API\u30ad\u30fc\u304c\u5fc5\u8981\u3067\u3059\u3002',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.teal),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // テーマ入力
              const Text(
                '\u306c\u308a\u3048\u306e\u30c6\u30fc\u30de',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _themeCtrl,
                decoration: InputDecoration(
                  hintText: '\u4f8b\uff1a\u685c\u3001\u732b\u3001\u5bcc\u58eb\u5c71\u3001\u91d1\u9b5a\u3001\u96ea\u3060\u308b\u307e...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                style: const TextStyle(fontSize: 18),
                onSubmitted: (_) => _generate(),
              ),
              const SizedBox(height: 16),

              // 生成ボタン
              ElevatedButton.icon(
                icon: _isGenerating
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Icon(Icons.auto_awesome, size: 24),
                label: Text(
                  _isGenerating
                      ? 'AI\u751f\u6210\u4e2d...'
                      : '\u306c\u308a\u3048\u3092\u751f\u6210\u3059\u308b',
                  style: const TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(double.infinity, 60),
                ),
                onPressed: _isGenerating ? null : _generate,
              ),
              if (_isGenerating)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    '\u5c11\u3005\u304a\u5f85\u3061\u304f\u3060\u3055\u3044\uff0810\u301c20\u79d2\u307b\u3069\u304b\u304b\u308a\u307e\u3059\uff09',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                ),

              // エラー
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_errorMessage!,
                            style: const TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              ],

              // プレビュー
              if (_pngBytes != null) ...[
                const SizedBox(height: 24),
                const Text(
                  '\u751f\u6210\u3055\u308c\u305f\u306c\u308a\u3048',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      _pngBytes!,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text(
                          '\u3082\u3046\u4e00\u5ea6\u751f\u6210',
                          style: TextStyle(fontSize: 15),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 52),
                        ),
                        onPressed: _isGenerating ? null : _generate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf, size: 22),
                        label: const Text(
                          'PDF\u4fdd\u5b58\u30fb\u5370\u5237',
                          style: TextStyle(fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.coloringColor,
                          minimumSize: const Size(0, 52),
                        ),
                        onPressed: _savePdf,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
