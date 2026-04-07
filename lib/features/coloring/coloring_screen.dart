import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

// 内蔵ぬりえテンプレート（SVGパスで将来実装予定。今はプレースホルダー）
const List<Map<String, dynamic>> _templates = [
  {'name': '桜', 'season': '春', 'icon': '🌸', 'difficulty': 'やさしい'},
  {'name': 'チューリップ', 'season': '春', 'icon': '🌷', 'difficulty': 'やさしい'},
  {'name': 'ひまわり', 'season': '夏', 'icon': '🌻', 'difficulty': 'ふつう'},
  {'name': '朝顔', 'season': '夏', 'icon': '🌺', 'difficulty': 'ふつう'},
  {'name': 'もみじ', 'season': '秋', 'icon': '🍁', 'difficulty': 'ふつう'},
  {'name': 'どんぐり', 'season': '秋', 'icon': '🌰', 'difficulty': 'やさしい'},
  {'name': '雪だるま', 'season': '冬', 'icon': '⛄', 'difficulty': 'やさしい'},
  {'name': '富士山', 'season': '通年', 'icon': '🗻', 'difficulty': 'ふつう'},
  {'name': '金魚', 'season': '夏', 'icon': '🐟', 'difficulty': 'やさしい'},
  {'name': 'うさぎ', 'season': '通年', 'icon': '🐇', 'difficulty': 'やさしい'},
  {'name': '猫', 'season': '通年', 'icon': '🐱', 'difficulty': 'ふつう'},
  {'name': '蝶々', 'season': '春', 'icon': '🦋', 'difficulty': 'むずかしい'},
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

            // 開発中のお知らせ
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.amber[50],
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.construction, size: 16, color: Colors.amber),
                  SizedBox(width: 6),
                  Text(
                    'ぬりえの線画データは順次追加予定です',
                    style: TextStyle(fontSize: 13, color: Colors.amber),
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
            Text(template['icon'], style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 8),
            Text(
              template['name'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              '季節: ${template['season']}　難易度: ${template['difficulty']}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            const Text(
              'このぬりえのPDFを作成します。\nA4で印刷してご使用ください。',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('PDF保存・印刷する'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coloringColor,
                minimumSize: const Size(double.infinity, 56),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${template['name']}のぬりえを準備中...'),
                    backgroundColor: AppColors.coloringColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
