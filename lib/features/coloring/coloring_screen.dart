import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'coloring_pdf_service.dart';
import 'ai_coloring_screen.dart';
import '../image_coloring/image_coloring_screen.dart';

// 内蔵ぬりえテンプレート（SVGパスで将来実装予定。今はプレースホルダー）
const List<Map<String, dynamic>> _templates = [
  // 春
  {'name': '桜', 'season': '春', 'icon': '🌸', 'difficulty': 'やさしい'},
  {'name': 'チューリップ', 'season': '春', 'icon': '🌷', 'difficulty': 'やさしい'},
  {'name': 'カーネーション', 'season': '春', 'icon': '💐', 'difficulty': 'ふつう'},
  {'name': 'こいのぼり', 'season': '春', 'icon': '🎏', 'difficulty': 'やさしい'},
  {'name': 'ひな人形', 'season': '春', 'icon': '🎎', 'difficulty': 'ふつう'},
  {'name': '蝶々', 'season': '春', 'icon': '🦋', 'difficulty': 'むずかしい'},
  // 夏
  {'name': 'ひまわり', 'season': '夏', 'icon': '🌻', 'difficulty': 'ふつう'},
  {'name': '朝顔', 'season': '夏', 'icon': '🌺', 'difficulty': 'ふつう'},
  {'name': '金魚', 'season': '夏', 'icon': '🐟', 'difficulty': 'やさしい'},
  {'name': 'スイカ', 'season': '夏', 'icon': '🍉', 'difficulty': 'やさしい'},
  {'name': '風鈴', 'season': '夏', 'icon': '🎐', 'difficulty': 'やさしい'},
  {'name': '花火', 'season': '夏', 'icon': '🎆', 'difficulty': 'ふつう'},
  {'name': 'かき氷', 'season': '夏', 'icon': '🍧', 'difficulty': 'やさしい'},
  // 秋
  {'name': 'もみじ', 'season': '秋', 'icon': '🍁', 'difficulty': 'ふつう'},
  {'name': 'どんぐり', 'season': '秋', 'icon': '🌰', 'difficulty': 'やさしい'},
  {'name': 'お月見', 'season': '秋', 'icon': '🌕', 'difficulty': 'ふつう'},
  {'name': '菊の花', 'season': '秋', 'icon': '🌼', 'difficulty': 'むずかしい'},
  {'name': 'トンボ', 'season': '秋', 'icon': '🪲', 'difficulty': 'ふつう'},
  // 冬
  {'name': '雪だるま', 'season': '冬', 'icon': '⛄', 'difficulty': 'やさしい'},
  {'name': '椿', 'season': '冬', 'icon': '🌺', 'difficulty': 'ふつう'},
  {'name': '門松', 'season': '冬', 'icon': '🎍', 'difficulty': 'ふつう'},
  {'name': '節分の鬼', 'season': '冬', 'icon': '👹', 'difficulty': 'ふつう'},
  {'name': 'みかん', 'season': '冬', 'icon': '🍊', 'difficulty': 'やさしい'},
  // 通年
  {'name': '富士山', 'season': '通年', 'icon': '🗻', 'difficulty': 'ふつう'},
  {'name': 'うさぎ', 'season': '通年', 'icon': '🐇', 'difficulty': 'やさしい'},
  {'name': '猫', 'season': '通年', 'icon': '🐱', 'difficulty': 'ふつう'},
  {'name': 'だるま', 'season': '通年', 'icon': '🎯', 'difficulty': 'やさしい'},
  {'name': '折り鶴', 'season': '通年', 'icon': '🕊️', 'difficulty': 'むずかしい'},
  {'name': '桃の花', 'season': '春', 'icon': '🌸', 'difficulty': 'やさしい'},
  {'name': 'ひし餅', 'season': '春', 'icon': '🍡', 'difficulty': 'やさしい'},
];

class ColoringScreen extends StatefulWidget {
  const ColoringScreen({super.key});

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  String _filterSeason = '全て';
  String _filterDifficulty = '全て';

  List<Map<String, dynamic>> get _filteredTemplates {
    return _templates.where((t) {
      final seasonOk = _filterSeason == '全て' || t['season'] == _filterSeason;
      final diffOk =
          _filterDifficulty == '全て' || t['difficulty'] == _filterDifficulty;
      return seasonOk && diffOk;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ぬりえを作る')),
      body: SafeArea(
        child: Column(
          children: [
            // フィルター
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 季節フィルター
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['全て', '春', '夏', '秋', '冬', '通年'].map((s) {
                        final selected = _filterSeason == s;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _filterSeason = s),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.coloringColor
                                    : Colors.white,
                                border: Border.all(
                                    color: selected
                                        ? AppColors.coloringColor
                                        : AppColors.border),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                s,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 難易度フィルター
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['全て', 'やさしい', 'ふつう', 'むずかしい'].map((d) {
                        final selected = _filterDifficulty == d;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _filterDifficulty = d),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: selected ? Colors.grey[700] : Colors.white,
                                border: Border.all(
                                    color: selected
                                        ? Colors.grey[700]!
                                        : AppColors.border),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                d,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // オリジナル作成ボタン群
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.auto_awesome, size: 20),
                      label: const Text(
                        'AI\u3067\u30aa\u30ea\u30b8\u30ca\u30eb',
                        style: TextStyle(fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AiColoringScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add_photo_alternate, size: 20),
                      label: const Text(
                        '\u5199\u771f\u30fbPDF\u304b\u3089',
                        style: TextStyle(fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ImageColoringScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // テンプレート一覧
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: _filteredTemplates.length,
                itemBuilder: (context, index) {
                  final t = _filteredTemplates[index];
                  return GestureDetector(
                    onTap: () => _showColoringDetail(context, t),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.border, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(t['icon'], style: const TextStyle(fontSize: 42)),
                          const SizedBox(height: 8),
                          Text(
                            t['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: t['difficulty'] == 'やさしい'
                                  ? Colors.green[100]
                                  : t['difficulty'] == 'ふつう'
                                      ? Colors.blue[100]
                                      : Colors.orange[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              t['difficulty'],
                              style: TextStyle(
                                fontSize: 11,
                                color: t['difficulty'] == 'やさしい'
                                    ? Colors.green[800]
                                    : t['difficulty'] == 'ふつう'
                                        ? Colors.blue[800]
                                        : Colors.orange[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 案内
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.teal.shade50,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: Colors.teal),
                  SizedBox(width: 6),
                  Text(
                    '\u30c6\u30f3\u30d7\u30ec\u30fc\u30c8\u3092\u30bf\u30c3\u30d7\u2192AI\u304c\u304d\u308c\u3044\u306a\u8f2a\u90ed\u7dda\u3092\u751f\u6210\u3057\u307e\u3059',
                    style: TextStyle(fontSize: 13, color: Colors.teal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColoringDetail(BuildContext context, Map<String, dynamic> template) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(template['icon'], style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 8),
            Text(
              template['name'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              '\u5b63\u7bc0: ${template['season']}\u3000\u96e3\u6613\u5ea6: ${template['difficulty']}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            // AI生成（推奨）
            ElevatedButton.icon(
              icon: const Icon(Icons.auto_awesome, size: 22),
              label: const Text(
                'AI\u3067\u304d\u308c\u3044\u306a\u306c\u308a\u3048\u3092\u4f5c\u308b\uff08\u304a\u3059\u3059\u3081\uff09',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 58),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AiColoringScreen(
                      initialTheme: template['name'] as String,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            // 従来のPDF（APIキーなしでも使用可）
            OutlinedButton.icon(
              icon: const Icon(Icons.picture_as_pdf, size: 18),
              label: const Text(
                '\u30b7\u30f3\u30d7\u30ebPDF\uff08API\u30ad\u30fc\u4e0d\u8981\uff09',
                style: TextStyle(fontSize: 14),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 46),
              ),
              onPressed: () async {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${template['name']}\u306e\u306c\u308a\u3048\u3092\u4f5c\u6210\u4e2d...'),
                    backgroundColor: AppColors.coloringColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
                try {
                  await ColoringPdfService.generateColoringPdf(
                    name: template['name'] as String,
                    season: template['season'] as String,
                    difficulty: template['difficulty'] as String,
                  );
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('\u30a8\u30e9\u30fc\u304c\u767a\u751f\u3057\u307e\u3057\u305f: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
