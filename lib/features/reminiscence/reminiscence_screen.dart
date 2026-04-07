import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_key_service.dart';
import '../../core/services/gemini_service.dart';
import '../../core/services/pdf_service.dart';

// 内蔵の回想法テーマと質問
const Map<String, List<String>> _builtinPrompts = {
  '昭和の台所': [
    'かまどでご飯を炊いたことはありますか？',
    '台所でよく作っていた料理は何でしたか？',
    'おひつに入れたご飯の味を覚えていますか？',
    'おかあさんの得意料理は何でしたか？',
    '薪や炭を使って料理しましたか？',
  ],
  '学校の思い出': [
    '通学路はどんな道でしたか？',
    '好きな先生はいましたか？どんな先生でしたか？',
    '給食や弁当はどんなものでしたか？',
    '休み時間にどんな遊びをしましたか？',
    'クラスでどんな役割をしていましたか？',
  ],
  '季節の行事': [
    'お正月にはどんなことをしましたか？',
    'お盆や夏祭りの思い出を教えてください',
    '子どもの頃の大晦日はどんな過ごし方でしたか？',
    '運動会や文化祭の思い出はありますか？',
    '節分の豆まきをしましたか？',
  ],
  '仕事の思い出': [
    'どんなお仕事をされていましたか？',
    '仕事で一番うれしかったことは何ですか？',
    '職場でよく食べていたお昼ご飯は何でしたか？',
    '仕事仲間との思い出を教えてください',
    '仕事を続けてきた中での苦労は何でしたか？',
  ],
  '子育ての思い出': [
    'お子さんが生まれた時の気持ちを教えてください',
    '子育てで大変だったことは何でしたか？',
    'お子さんと一緒によく行った場所はどこでしたか？',
    '子どもに教えたことや伝えたことはありますか？',
    '子育てで楽しかったことを教えてください',
  ],
};

class ReminiscenceScreen extends ConsumerStatefulWidget {
  const ReminiscenceScreen({super.key});

  @override
  ConsumerState<ReminiscenceScreen> createState() =>
      _ReminiscenceScreenState();
}

class _ReminiscenceScreenState extends ConsumerState<ReminiscenceScreen> {
  String _selectedTheme = '昭和の台所';
  List<String> _prompts = [];
  bool _isLoading = false;
  bool _usedAi = false;

  void _loadBuiltin() {
    setState(() {
      _prompts = List.from(_builtinPrompts[_selectedTheme] ?? []);
      _usedAi = false;
    });
  }

  Future<void> _generateWithAi() async {
    final hasKey = await ref.read(hasGeminiApiKeyProvider.future);
    if (!hasKey) {
      if (!mounted) return;
      _showApiKeyDialog();
      return;
    }

    setState(() => _isLoading = true);
    try {
      final service = ref.read(apiKeyServiceProvider);
      final gemini = GeminiService(service);
      final prompts = await gemini.generateReminiscencePrompts(_selectedTheme);
      setState(() {
        _prompts = prompts;
        _usedAi = true;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('AI生成エラー: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showApiKeyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('APIキーが必要です'),
        content: const Text(
          'AI自動生成にはGemini APIキーが必要です。\n\n設定画面でAPIキーを入力すると使えるようになります。\n\n内蔵の質問リストは無料で使えます。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('閉じる'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _loadBuiltin(); // 無料版にフォールバック
            },
            child: const Text('内蔵の質問を使う（無料）'),
          ),
        ],
      ),
    );
  }

  Future<void> _savePdf() async {
    if (_prompts.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await pdfService.generateCalculationPdf(
        title: '$_selectedTheme　回想法カード',
        questions: _prompts,
        fontSize: 20,
      );
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラー: $e'), backgroundColor: AppColors.danger),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('回想法カードを作る')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 説明
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.reminColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: AppColors.reminColor.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: AppColors.reminColor),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '昔の記憶を引き出す問いかけカードを作ります。\nグループ活動・個人療法どちらにも使えます。',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // テーマ選択
              const Text('テーマを選ぶ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: _builtinPrompts.keys
                    .map((theme) => GestureDetector(
                          onTap: () {
                            setState(() => _selectedTheme = theme);
                            _loadBuiltin();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: _selectedTheme == theme
                                  ? AppColors.reminColor
                                  : Colors.white,
                              border: Border.all(
                                color: _selectedTheme == theme
                                    ? AppColors.reminColor
                                    : AppColors.border,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              theme,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: _selectedTheme == theme
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _selectedTheme == theme
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),

              // 生成ボタン2種
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.list),
                      label: const Text('内蔵の質問を使う\n（無料）'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.reminColor,
                        minimumSize: const Size(0, 60),
                      ),
                      onPressed: _loadBuiltin,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('AIで生成する\n（APIキー必要）'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.reminColor,
                        side: const BorderSide(
                            color: AppColors.reminColor, width: 2),
                        minimumSize: const Size(0, 60),
                      ),
                      onPressed: _isLoading ? null : _generateWithAi,
                    ),
                  ),
                ],
              ),

              // 生成中インジケーター
              if (_isLoading) ...[
                const SizedBox(height: 20),
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 8),
                const Center(child: Text('AIが問いかけを作っています...')),
              ],

              // 問いかけ一覧
              if (_prompts.isNotEmpty) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$_selectedTheme　問いかけ${_usedAi ? "（AI生成）" : "（内蔵）"}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.surface,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _prompts.asMap().entries.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.reminColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${e.key + 1}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  e.value,
                                  style: const TextStyle(
                                      fontSize: 17, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.picture_as_pdf),
                  label: Text(_isLoading ? 'PDF作成中...' : 'PDF保存・印刷する'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.reminColor),
                  onPressed: _isLoading ? null : _savePdf,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
