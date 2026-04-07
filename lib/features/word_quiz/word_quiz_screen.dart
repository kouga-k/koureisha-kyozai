import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/pdf_service.dart';

// 内蔵辞書：テーマ別単語
const Map<String, List<String>> _themeWords = {
  '春': ['さくら', 'たんぽぽ', 'うめ', 'つくし', 'はるかぜ', 'うぐいす', 'てんとうむし'],
  '夏': ['かき氷', 'すいか', 'ひまわり', 'せみ', 'なつまつり', 'はなび', 'うちわ'],
  '秋': ['もみじ', 'どんぐり', 'きのこ', 'おつきみ', 'くり', 'かき', 'こうよう'],
  '冬': ['ゆき', 'こたつ', 'もちつき', 'おしょうがつ', 'たき火', 'ゆきだるま', 'せつぶん'],
  '昭和の暮らし': ['かまど', 'はんしゃく', 'ちゃぶ台', 'ぼんぼり', 'いろり', 'ながや', 'しょうじ'],
  '食べ物': ['おにぎり', 'みそしる', 'てんぷら', 'すし', 'うどん', 'そば', 'おかゆ'],
  '動物': ['ねこ', 'いぬ', 'うさぎ', 'さる', 'むま', 'にわとり', 'かめ'],
};

// ことわざ辞書
const List<Map<String, String>> _kotowaza = [
  {'q': '石の上にも●●●', 'a': '三年'},
  {'q': '七転び●●●●', 'a': '八起き'},
  {'q': 'はなより●●●', 'a': 'だんご'},
  {'q': 'ちりも積もれば●●●●●', 'a': '山となる'},
  {'q': '猫に●●●', 'a': '小判'},
  {'q': '犬も歩けば●●に当たる', 'a': '棒'},
  {'q': '笑う門には●●●●●', 'a': '福来る'},
  {'q': '急がば●●れ', 'a': '回'},
];

enum WordQuizType { fillBlank, rearrange, kotowaza }

class WordQuizScreen extends StatefulWidget {
  const WordQuizScreen({super.key});

  @override
  State<WordQuizScreen> createState() => _WordQuizScreenState();
}

class _WordQuizScreenState extends State<WordQuizScreen> {
  WordQuizType _quizType = WordQuizType.fillBlank;
  String _selectedTheme = '春';
  List<Map<String, String>> _questions = [];
  bool _isGenerating = false;

  void _generate() {
    switch (_quizType) {
      case WordQuizType.fillBlank:
        _generateFillBlank();
        break;
      case WordQuizType.rearrange:
        _generateRearrange();
        break;
      case WordQuizType.kotowaza:
        _generateKotowaza();
        break;
    }
  }

  void _generateFillBlank() {
    final words = _themeWords[_selectedTheme] ?? [];
    final rand = Random();
    final questions = <Map<String, String>>[];

    for (final word in words.take(8)) {
      // ランダムに1文字を●に変換
      final idx = rand.nextInt(word.length);
      final blanked =
          word.substring(0, idx) + '●' + word.substring(idx + 1);
      questions.add({'q': '【$_selectedTheme】$blanked', 'a': word});
    }

    setState(() => _questions = questions);
  }

  void _generateRearrange() {
    final words = _themeWords[_selectedTheme] ?? [];
    final rand = Random();
    final questions = <Map<String, String>>[];

    for (final word in words.take(8)) {
      final chars = word.split('')..shuffle(rand);
      final shuffled = chars.join('　');
      questions.add({'q': '[$shuffled]　→　答え：＿＿＿＿', 'a': word});
    }

    setState(() => _questions = questions);
  }

  void _generateKotowaza() {
    final rand = Random();
    final selected = [..._kotowaza]..shuffle(rand);
    setState(() => _questions = selected.take(6).toList());
  }

  Future<void> _savePdf() async {
    setState(() => _isGenerating = true);
    try {
      String title;
      switch (_quizType) {
        case WordQuizType.fillBlank:
          title = '$_selectedTheme の穴埋め問題';
          break;
        case WordQuizType.rearrange:
          title = '$_selectedTheme の並べ替え問題';
          break;
        case WordQuizType.kotowaza:
          title = 'ことわざ 穴埋め問題';
          break;
      }

      final questionsText = _questions.map((e) => e['q']!).toList();
      await pdfService.generateCalculationPdf(
        title: title,
        questions: questionsText,
        fontSize: 22,
      );
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラー: $e'), backgroundColor: AppColors.danger),
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('言葉問題を作る')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 問題の種類
              const Text('問題の種類',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  _Chip(
                    label: '穴埋め問題',
                    selected: _quizType == WordQuizType.fillBlank,
                    color: AppColors.wordColor,
                    onTap: () => setState(() => _quizType = WordQuizType.fillBlank),
                  ),
                  _Chip(
                    label: '並べ替え',
                    selected: _quizType == WordQuizType.rearrange,
                    color: AppColors.wordColor,
                    onTap: () => setState(() => _quizType = WordQuizType.rearrange),
                  ),
                  _Chip(
                    label: 'ことわざ完成',
                    selected: _quizType == WordQuizType.kotowaza,
                    color: AppColors.wordColor,
                    onTap: () => setState(() => _quizType = WordQuizType.kotowaza),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // テーマ選択（ことわざ以外）
              if (_quizType != WordQuizType.kotowaza) ...[
                const Text('テーマ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: _themeWords.keys
                      .map((theme) => _Chip(
                            label: theme,
                            selected: _selectedTheme == theme,
                            color: AppColors.wordColor,
                            onTap: () => setState(() => _selectedTheme = theme),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
              ],

              // 生成ボタン
              ElevatedButton.icon(
                icon: const Icon(Icons.auto_awesome),
                label: const Text('問題を作る'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.wordColor),
                onPressed: _generate,
              ),

              // 問題プレビュー
              if (_questions.isNotEmpty) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '生成された問題（答えは編集できます）',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('作り直す'),
                      onPressed: _generate,
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
                    children: _questions.asMap().entries.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '(${e.key + 1}) ',
                                style: const TextStyle(fontSize: 18),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.value['q']!,
                                      style: const TextStyle(fontSize: 18, height: 1.6),
                                    ),
                                    Text(
                                      '答え：${e.value['a']}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.picture_as_pdf),
                  label: Text(_isGenerating ? 'PDF作成中...' : 'PDF保存・印刷する'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.wordColor),
                  onPressed: _isGenerating ? null : _savePdf,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          border: Border.all(
            color: selected ? color : AppColors.border,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
