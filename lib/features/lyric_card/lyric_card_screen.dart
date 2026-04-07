import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/pdf_service.dart';
import 'lyric_card_editor.dart';

class LyricCardScreen extends ConsumerStatefulWidget {
  const LyricCardScreen({super.key});

  @override
  ConsumerState<LyricCardScreen> createState() => _LyricCardScreenState();
}

class _LyricCardScreenState extends ConsumerState<LyricCardScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('歌詞カードを作る')),
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
                  color: AppColors.lyricColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.lyricColor.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.lyricColor),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '曲のタイトルと歌詞を入力してください。\nA4の大きな文字カードが作れます。',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // タイトル入力
              const Text(
                '曲のタイトル',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: '例：ふるさと',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),

              // 歌詞入力
              const Text(
                '歌詞',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _bodyController,
                maxLines: 12,
                decoration: const InputDecoration(
                  hintText: 'ここに歌詞を貼り付けるか、入力してください',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
              const SizedBox(height: 8),
              const Text(
                '※ PDFや別のアプリからコピーして貼り付けもできます',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),

              // 作成ボタン
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text('カードを作る'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lyricColor,
                ),
                onPressed: () {
                  final title = _titleController.text.trim();
                  final body = _bodyController.text.trim();
                  if (title.isEmpty || body.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('タイトルと歌詞を入力してください'),
                        backgroundColor: AppColors.warning,
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LyricCardEditor(
                        initialTitle: title,
                        initialBody: body,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
