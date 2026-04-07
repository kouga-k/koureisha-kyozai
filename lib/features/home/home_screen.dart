import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../settings/settings_screen.dart';
import '../lyric_card/lyric_card_screen.dart';
import '../calculation/calculation_screen.dart';
import '../word_quiz/word_quiz_screen.dart';
import '../reminiscence/reminiscence_screen.dart';
import '../coloring/coloring_screen.dart';
import '../saved/saved_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('高齢者向け教材作成'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 28),
            tooltip: '設定',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ヘッダー
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.menu_book, size: 48, color: AppColors.primary),
                    SizedBox(height: 8),
                    Text(
                      '何を作りますか？',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '下のボタンから作りたい教材を選んでください',
                      style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 教材選択グリッド
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.1,
                children: [
                  _FeatureButton(
                    icon: Icons.music_note,
                    label: '歌詞カード',
                    description: '歌詞を大きく\n読みやすく',
                    color: AppColors.lyricColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LyricCardScreen()),
                    ),
                  ),
                  _FeatureButton(
                    icon: Icons.calculate,
                    label: '計算問題',
                    description: '足し算・引き算\nお金の計算',
                    color: AppColors.calcColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CalculationScreen()),
                    ),
                  ),
                  _FeatureButton(
                    icon: Icons.spellcheck,
                    label: '言葉問題',
                    description: '穴埋め・並べ替え\ことわざ',
                    color: AppColors.wordColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WordQuizScreen()),
                    ),
                  ),
                  _FeatureButton(
                    icon: Icons.photo_album,
                    label: '回想法カード',
                    description: '昔の記憶を\n引き出す',
                    color: AppColors.reminColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReminiscenceScreen()),
                    ),
                  ),
                  _FeatureButton(
                    icon: Icons.brush,
                    label: 'ぬりえ',
                    description: 'テンプレートから\n選ぶ',
                    color: AppColors.coloringColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ColoringScreen()),
                    ),
                  ),
                  _FeatureButton(
                    icon: Icons.folder_open,
                    label: '保存済み',
                    description: '作った教材を\n開く・印刷',
                    color: AppColors.textSecondary,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SavedScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _FeatureButton({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.4), width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
