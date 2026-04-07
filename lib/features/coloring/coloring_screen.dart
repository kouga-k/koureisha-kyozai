import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'coloring_pdf_service.dart';
import 'ai_coloring_screen.dart';
import '../image_coloring/image_coloring_screen.dart';

// ===================== カテゴリー設定 =====================

const Map<String, Color> _catColors = {
  '1月': Color(0xFF5B8BD0),
  '2月': Color(0xFF9B7FBE),
  '3月': Color(0xFFE899B0),
  '4月': Color(0xFFE06080),
  '5月': Color(0xFF52A862),
  '6月': Color(0xFF7894C0),
  '7月': Color(0xFF3A8EC2),
  '8月': Color(0xFFF0980A),
  '9月': Color(0xFFC07840),
  '10月': Color(0xFFD0581A),
  '11月': Color(0xFF8B5E3C),
  '12月': Color(0xFFCC3333),
  '動物': Color(0xFF3CAE6E),
  '花・植物': Color(0xFFD05080),
  '食べ物': Color(0xFFF09010),
  '日本の文化': Color(0xFF8B3A3A),
};

const Map<String, String> _catIcons = {
  '1月': '⛄', '2月': '💐', '3月': '🎎', '4月': '🌸',
  '5月': '🎏', '6月': '☔', '7月': '🎆', '8月': '🌻',
  '9月': '🌕', '10月': '🎃', '11月': '🍁', '12月': '🎄',
  '動物': '🐾', '花・植物': '🌺', '食べ物': '🍱', '日本の文化': '⛩️',
};

const _monthCategories = [
  '1月', '2月', '3月', '4月', '5月', '6月',
  '7月', '8月', '9月', '10月', '11月', '12月',
];
const _otherCategories = ['動物', '花・植物', '食べ物', '日本の文化'];

// ===================== テンプレートデータ =====================

const Map<String, List<Map<String, dynamic>>> _allTemplates = {
  '1月': [
    {'name': 'お正月飾り（門松）', 'icon': '🎍', 'difficulty': 'ふつう'},
    {'name': '初日の出と富士山', 'icon': '🗻', 'difficulty': 'ふつう'},
    {'name': '鶴と松', 'icon': '🕊️', 'difficulty': 'ふつう'},
    {'name': '羽子板と羽根', 'icon': '🏓', 'difficulty': 'やさしい'},
    {'name': '凧あげ', 'icon': '🪁', 'difficulty': 'やさしい'},
    {'name': '雪景色', 'icon': '❄️', 'difficulty': 'ふつう'},
    {'name': 'みかんとこたつ', 'icon': '🍊', 'difficulty': 'やさしい'},
    {'name': '獅子舞', 'icon': '🦁', 'difficulty': 'むずかしい'},
    {'name': '雪だるま', 'icon': '⛄', 'difficulty': 'やさしい'},
    {'name': '七福神の宝船', 'icon': '⛵', 'difficulty': 'むずかしい'},
  ],
  '2月': [
    {'name': '節分の鬼', 'icon': '👹', 'difficulty': 'ふつう'},
    {'name': '豆まき', 'icon': '🫘', 'difficulty': 'やさしい'},
    {'name': 'バレンタインのチョコ', 'icon': '🍫', 'difficulty': 'やさしい'},
    {'name': '梅の花', 'icon': '🌸', 'difficulty': 'ふつう'},
    {'name': '恵方巻き', 'icon': '🍱', 'difficulty': 'やさしい'},
    {'name': 'うぐいすと梅', 'icon': '🐦', 'difficulty': 'ふつう'},
    {'name': '福の神', 'icon': '😊', 'difficulty': 'ふつう'},
    {'name': '雪景色と冬木立', 'icon': '🌲', 'difficulty': 'やさしい'},
  ],
  '3月': [
    {'name': 'ひな人形', 'icon': '🎎', 'difficulty': 'むずかしい'},
    {'name': '桃の花', 'icon': '🌸', 'difficulty': 'やさしい'},
    {'name': '菜の花畑', 'icon': '🌼', 'difficulty': 'やさしい'},
    {'name': 'クローバー', 'icon': '🍀', 'difficulty': 'やさしい'},
    {'name': '春の蝶々', 'icon': '🦋', 'difficulty': 'ふつう'},
    {'name': 'さくらもち', 'icon': '🍡', 'difficulty': 'やさしい'},
    {'name': '卒業の花束', 'icon': '💐', 'difficulty': 'ふつう'},
    {'name': 'つくしんぼ', 'icon': '🌱', 'difficulty': 'やさしい'},
  ],
  '4月': [
    {'name': '桜の花', 'icon': '🌸', 'difficulty': 'ふつう'},
    {'name': 'お花見と富士山', 'icon': '🗻', 'difficulty': 'ふつう'},
    {'name': 'チューリップ畑', 'icon': '🌷', 'difficulty': 'やさしい'},
    {'name': 'タンポポと春の野', 'icon': '🌼', 'difficulty': 'やさしい'},
    {'name': 'てんとうむし', 'icon': '🐞', 'difficulty': 'やさしい'},
    {'name': 'ランドセル', 'icon': '🎒', 'difficulty': 'やさしい'},
    {'name': 'うぐいす', 'icon': '🐦', 'difficulty': 'ふつう'},
    {'name': '春の小川', 'icon': '💧', 'difficulty': 'ふつう'},
  ],
  '5月': [
    {'name': 'こいのぼり', 'icon': '🎏', 'difficulty': 'やさしい'},
    {'name': '鎧と兜（端午）', 'icon': '⛑️', 'difficulty': 'むずかしい'},
    {'name': 'カーネーション（母の日）', 'icon': '💐', 'difficulty': 'ふつう'},
    {'name': 'バラ', 'icon': '🌹', 'difficulty': 'ふつう'},
    {'name': '藤の花', 'icon': '🌿', 'difficulty': 'ふつう'},
    {'name': '新緑の木', 'icon': '🌳', 'difficulty': 'やさしい'},
    {'name': '菖蒲（あやめ）', 'icon': '🌺', 'difficulty': 'ふつう'},
    {'name': 'かぶとむし（幼虫）', 'icon': '🐛', 'difficulty': 'やさしい'},
  ],
  '6月': [
    {'name': 'あじさい', 'icon': '💠', 'difficulty': 'ふつう'},
    {'name': 'かたつむり', 'icon': '🐌', 'difficulty': 'やさしい'},
    {'name': 'あまがえる', 'icon': '🐸', 'difficulty': 'やさしい'},
    {'name': '梅雨の傘と雨', 'icon': '☂️', 'difficulty': 'やさしい'},
    {'name': 'ホタル', 'icon': '✨', 'difficulty': 'ふつう'},
    {'name': '長靴と水たまり', 'icon': '🥾', 'difficulty': 'やさしい'},
    {'name': '梅の実', 'icon': '🍈', 'difficulty': 'やさしい'},
    {'name': '田植えの風景', 'icon': '🌾', 'difficulty': 'ふつう'},
  ],
  '7月': [
    {'name': '七夕の飾り', 'icon': '🎋', 'difficulty': 'ふつう'},
    {'name': '金魚すくい', 'icon': '🐟', 'difficulty': 'やさしい'},
    {'name': 'ひまわり', 'icon': '🌻', 'difficulty': 'ふつう'},
    {'name': '打ち上げ花火', 'icon': '🎆', 'difficulty': 'ふつう'},
    {'name': 'スイカ', 'icon': '🍉', 'difficulty': 'やさしい'},
    {'name': '朝顔', 'icon': '🌺', 'difficulty': 'ふつう'},
    {'name': '浴衣の女の子', 'icon': '👘', 'difficulty': 'むずかしい'},
    {'name': '風鈴', 'icon': '🎐', 'difficulty': 'やさしい'},
    {'name': '夏のお神輿', 'icon': '⛩️', 'difficulty': 'むずかしい'},
  ],
  '8月': [
    {'name': 'かき氷', 'icon': '🍧', 'difficulty': 'やさしい'},
    {'name': '夏の海と貝', 'icon': '🏖️', 'difficulty': 'ふつう'},
    {'name': '盆踊り', 'icon': '🎵', 'difficulty': 'むずかしい'},
    {'name': 'セミ', 'icon': '🦗', 'difficulty': 'ふつう'},
    {'name': 'スイカ割り', 'icon': '🍉', 'difficulty': 'やさしい'},
    {'name': 'トウモロコシ', 'icon': '🌽', 'difficulty': 'やさしい'},
    {'name': 'カブトムシ', 'icon': '🪲', 'difficulty': 'ふつう'},
    {'name': '砂浜とヤドカリ', 'icon': '🦀', 'difficulty': 'やさしい'},
    {'name': 'ひまわり畑', 'icon': '🌻', 'difficulty': 'ふつう'},
  ],
  '9月': [
    {'name': 'お月見（うさぎと月）', 'icon': '🌕', 'difficulty': 'ふつう'},
    {'name': 'コスモス', 'icon': '🌸', 'difficulty': 'やさしい'},
    {'name': '栗ひろい', 'icon': '🌰', 'difficulty': 'やさしい'},
    {'name': 'ぶどう', 'icon': '🍇', 'difficulty': 'ふつう'},
    {'name': '赤とんぼ', 'icon': '🪲', 'difficulty': 'ふつう'},
    {'name': 'さんま', 'icon': '🐟', 'difficulty': 'やさしい'},
    {'name': '稲穂と案山子', 'icon': '🌾', 'difficulty': 'ふつう'},
    {'name': 'お月見のお団子', 'icon': '🍡', 'difficulty': 'やさしい'},
  ],
  '10月': [
    {'name': 'ハロウィンのかぼちゃ', 'icon': '🎃', 'difficulty': 'やさしい'},
    {'name': 'もみじ', 'icon': '🍁', 'difficulty': 'ふつう'},
    {'name': 'きのこ', 'icon': '🍄', 'difficulty': 'やさしい'},
    {'name': 'どんぐり', 'icon': '🌰', 'difficulty': 'やさしい'},
    {'name': '柿', 'icon': '🍊', 'difficulty': 'やさしい'},
    {'name': 'かかし', 'icon': '🧑‍🌾', 'difficulty': 'ふつう'},
    {'name': '魔女とほうき', 'icon': '🧙', 'difficulty': 'ふつう'},
    {'name': '秋の里山', 'icon': '🏔️', 'difficulty': 'ふつう'},
    {'name': '芋ほり', 'icon': '🍠', 'difficulty': 'やさしい'},
  ],
  '11月': [
    {'name': '紅葉の木', 'icon': '🍁', 'difficulty': 'ふつう'},
    {'name': '七五三の着物', 'icon': '👘', 'difficulty': 'むずかしい'},
    {'name': '菊の花', 'icon': '🌼', 'difficulty': 'むずかしい'},
    {'name': '落ち葉あつめ', 'icon': '🍂', 'difficulty': 'やさしい'},
    {'name': '大根', 'icon': '🥬', 'difficulty': 'やさしい'},
    {'name': '柚子', 'icon': '🍋', 'difficulty': 'やさしい'},
    {'name': 'みのむし', 'icon': '🐛', 'difficulty': 'やさしい'},
    {'name': '紅葉狩り', 'icon': '🏔️', 'difficulty': 'ふつう'},
  ],
  '12月': [
    {'name': 'クリスマスツリー', 'icon': '🎄', 'difficulty': 'ふつう'},
    {'name': 'サンタクロース', 'icon': '🎅', 'difficulty': 'ふつう'},
    {'name': '雪の結晶', 'icon': '❄️', 'difficulty': 'ふつう'},
    {'name': 'クリスマスリース', 'icon': '🎉', 'difficulty': 'ふつう'},
    {'name': '鏡餅と橙', 'icon': '🍊', 'difficulty': 'やさしい'},
    {'name': '年越しそば', 'icon': '🍜', 'difficulty': 'やさしい'},
    {'name': 'ゆず湯', 'icon': '🍋', 'difficulty': 'やさしい'},
    {'name': '冬の鳥（シジュウカラ）', 'icon': '🕊️', 'difficulty': 'ふつう'},
    {'name': '大掃除', 'icon': '🧹', 'difficulty': 'やさしい'},
  ],
  '動物': [
    {'name': '猫', 'icon': '🐱', 'difficulty': 'ふつう'},
    {'name': '犬', 'icon': '🐶', 'difficulty': 'やさしい'},
    {'name': 'うさぎ', 'icon': '🐰', 'difficulty': 'やさしい'},
    {'name': 'パンダ', 'icon': '🐼', 'difficulty': 'やさしい'},
    {'name': '小鳥（スズメ）', 'icon': '🐦', 'difficulty': 'やさしい'},
    {'name': '金魚', 'icon': '🐟', 'difficulty': 'やさしい'},
    {'name': '亀', 'icon': '🐢', 'difficulty': 'やさしい'},
    {'name': '鶴', 'icon': '🕊️', 'difficulty': 'ふつう'},
    {'name': 'リス', 'icon': '🐿️', 'difficulty': 'やさしい'},
    {'name': 'ハムスター', 'icon': '🐹', 'difficulty': 'やさしい'},
    {'name': 'ふくろう', 'icon': '🦉', 'difficulty': 'ふつう'},
    {'name': 'たぬき', 'icon': '🦝', 'difficulty': 'ふつう'},
  ],
  '花・植物': [
    {'name': '桜', 'icon': '🌸', 'difficulty': 'ふつう'},
    {'name': 'バラ', 'icon': '🌹', 'difficulty': 'ふつう'},
    {'name': 'ひまわり', 'icon': '🌻', 'difficulty': 'ふつう'},
    {'name': 'チューリップ', 'icon': '🌷', 'difficulty': 'やさしい'},
    {'name': '菊', 'icon': '🌼', 'difficulty': 'むずかしい'},
    {'name': 'あじさい', 'icon': '💠', 'difficulty': 'ふつう'},
    {'name': '蓮の花', 'icon': '🪷', 'difficulty': 'ふつう'},
    {'name': 'コスモス', 'icon': '🌸', 'difficulty': 'やさしい'},
    {'name': '桃の花', 'icon': '🌸', 'difficulty': 'やさしい'},
    {'name': '梅の花', 'icon': '🌸', 'difficulty': 'ふつう'},
    {'name': '藤の花', 'icon': '🌿', 'difficulty': 'ふつう'},
    {'name': '朝顔', 'icon': '🌺', 'difficulty': 'ふつう'},
  ],
  '食べ物': [
    {'name': 'おにぎり', 'icon': '🍙', 'difficulty': 'やさしい'},
    {'name': 'お寿司', 'icon': '🍣', 'difficulty': 'ふつう'},
    {'name': '和菓子（饅頭）', 'icon': '🍡', 'difficulty': 'やさしい'},
    {'name': 'お団子', 'icon': '🍡', 'difficulty': 'やさしい'},
    {'name': '抹茶と茶碗', 'icon': '🍵', 'difficulty': 'やさしい'},
    {'name': 'お弁当', 'icon': '🍱', 'difficulty': 'ふつう'},
    {'name': 'たこ焼き', 'icon': '🐙', 'difficulty': 'やさしい'},
    {'name': 'ラーメン', 'icon': '🍜', 'difficulty': 'ふつう'},
    {'name': '天ぷら', 'icon': '🍤', 'difficulty': 'ふつう'},
    {'name': 'たい焼き', 'icon': '🐟', 'difficulty': 'やさしい'},
  ],
  '日本の文化': [
    {'name': '富士山', 'icon': '🗻', 'difficulty': 'ふつう'},
    {'name': '折り鶴', 'icon': '🕊️', 'difficulty': 'むずかしい'},
    {'name': 'だるま', 'icon': '🎯', 'difficulty': 'やさしい'},
    {'name': '着物', 'icon': '👘', 'difficulty': 'むずかしい'},
    {'name': '茶道（茶碗）', 'icon': '🍵', 'difficulty': 'やさしい'},
    {'name': '神社の鳥居', 'icon': '⛩️', 'difficulty': 'ふつう'},
    {'name': '歌舞伎の顔', 'icon': '🎭', 'difficulty': 'むずかしい'},
    {'name': '扇子', 'icon': '🪭', 'difficulty': 'やさしい'},
    {'name': '招き猫', 'icon': '🐱', 'difficulty': 'ふつう'},
    {'name': '提灯', 'icon': '🏮', 'difficulty': 'やさしい'},
  ],
};

// ===================== 画面 =====================

class ColoringScreen extends StatefulWidget {
  const ColoringScreen({super.key});

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  late String _selectedCategory;
  String _filterDifficulty = '全て';

  @override
  void initState() {
    super.initState();
    // 今月を初期値に
    _selectedCategory = '${DateTime.now().month}月';
  }

  List<Map<String, dynamic>> get _filteredTemplates {
    final templates = _allTemplates[_selectedCategory] ?? [];
    if (_filterDifficulty == '全て') return templates;
    return templates.where((t) => t['difficulty'] == _filterDifficulty).toList();
  }

  Color get _currentColor => _catColors[_selectedCategory] ?? Colors.grey;
  String get _currentIcon => _catIcons[_selectedCategory] ?? '📌';

  @override
  Widget build(BuildContext context) {
    final templates = _filteredTemplates;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        title: const Text('ぬりえを作る'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ─── ヘッダーバナー ───
            _buildHeaderBanner(),

            // ─── カテゴリー選択バー ───
            _buildCategoryBar(),

            // ─── 難易度フィルター ───
            _buildDifficultyFilter(),

            // ─── テンプレート一覧 ───
            Expanded(
              child: templates.isEmpty
                  ? _buildEmpty()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: templates.length,
                      itemBuilder: (context, i) =>
                          _buildTemplateCard(context, templates[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    final color = _currentColor;
    final icon = _currentIcon;
    final count = (_allTemplates[_selectedCategory] ?? []).length;
    final isMonth = _monthCategories.contains(_selectedCategory);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.65)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMonth ? '$_selectedCategory のぬりえ' : '$_selectedCategory のぬりえ',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$count種類から選べます ✨',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9), fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildHeaderBtn(
                  icon: '✨',
                  label: 'AIで作る',
                  color: Colors.white,
                  textColor: color,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AiColoringScreen()),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildHeaderBtn(
                  icon: '📷',
                  label: '写真・PDFから',
                  color: Colors.white.withOpacity(0.25),
                  textColor: Colors.white,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ImageColoringScreen()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBtn({
    required String icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 64,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // 月 (1〜12月)
            ...List.generate(12, (i) {
              final cat = '${i + 1}月';
              return _buildCategoryChip(cat, isMonth: true);
            }),
            // 区切り
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 1.5,
              height: 30,
              color: Colors.grey.shade300,
            ),
            // その他カテゴリー
            ..._otherCategories.map((c) => _buildCategoryChip(c)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String cat, {bool isMonth = false}) {
    final selected = _selectedCategory == cat;
    final color = _catColors[cat] ?? Colors.grey;
    final icon = _catIcons[cat] ?? '';

    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = cat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 7),
        padding: EdgeInsets.symmetric(
            horizontal: isMonth ? 10 : 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(22),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2))
                ]
              : [],
        ),
        child: isMonth
            ? Text(
                cat,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : color,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(icon, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    cat,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.white : color,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDifficultyFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
      child: Row(
        children: ['全て', 'やさしい', 'ふつう', 'むずかしい'].map((d) {
          final selected = _filterDifficulty == d;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _filterDifficulty = d),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: selected ? Colors.grey[700] : Colors.white,
                  border: Border.all(
                      color:
                          selected ? Colors.grey[700]! : Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  d,
                  style: TextStyle(
                    fontSize: 12,
                    color: selected ? Colors.white : Colors.grey[700],
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTemplateCard(
      BuildContext context, Map<String, dynamic> template) {
    final color = _currentColor;
    final diff = template['difficulty'] as String;
    final diffColor = diff == 'やさしい'
        ? const Color(0xFF52A862)
        : diff == 'ふつう'
            ? const Color(0xFF3A8EC2)
            : const Color(0xFFD07020);

    return GestureDetector(
      onTap: () => _showDetail(context, template),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 背景グラデーション
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.1),
                      color.withOpacity(0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // 内容
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    template['icon'],
                    style: const TextStyle(fontSize: 50),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    template['name'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A2A2A),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: diffColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: diffColor.withOpacity(0.5), width: 1),
                    ),
                    child: Text(
                      diff,
                      style: TextStyle(
                          fontSize: 11,
                          color: diffColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            // タップヒント
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.touch_app,
                    size: 14, color: color.withOpacity(0.6)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('😊', style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text('このカテゴリーの難易度は\nまだ準備中です',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 15, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, Map<String, dynamic> template) {
    final color = _currentColor;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ハンドル
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(template['icon'], style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 8),
            Text(
              template['name'],
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '$_selectedCategory　難易度: ${template['difficulty']}',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            // AI生成ボタン（推奨）
            ElevatedButton.icon(
              icon: const Text('✨', style: TextStyle(fontSize: 18)),
              label: const Text(
                'AIできれいなぬりえを作る（おすすめ）',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AiColoringScreen(
                        initialTheme: template['name'] as String),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            // シンプルPDF
            OutlinedButton.icon(
              icon: const Icon(Icons.picture_as_pdf, size: 18),
              label: const Text('シンプルPDF（APIキー不要）',
                  style: TextStyle(fontSize: 13)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 46),
                side: BorderSide(color: color.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${template['name']}のぬりえを作成中...'),
                    backgroundColor: color,
                    duration: const Duration(seconds: 2),
                  ),
                );
                try {
                  await ColoringPdfService.generateColoringPdf(
                    name: template['name'] as String,
                    season: _selectedCategory,
                    difficulty: template['difficulty'] as String,
                  );
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('エラー: $e'),
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
