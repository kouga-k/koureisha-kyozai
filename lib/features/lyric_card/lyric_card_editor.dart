import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/pdf_service.dart';

class LyricCardEditor extends StatefulWidget {
  final String initialTitle;
  final String initialBody;

  const LyricCardEditor({
    super.key,
    required this.initialTitle,
    required this.initialBody,
  });

  @override
  State<LyricCardEditor> createState() => _LyricCardEditorState();
}

class _LyricCardEditorState extends State<LyricCardEditor> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  bool _landscape = false;
  int _fontSize = 24;
  double _lineHeight = 2.0;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _bodyController = TextEditingController(text: widget.initialBody);
  }

  Future<void> _generatePdf() async {
    setState(() => _isGenerating = true);
    try {
      await pdfService.generateLyricCardPdf(
        title: _titleController.text,
        body: _bodyController.text,
        landscape: _landscape,
        fontSize: _fontSize,
        lineHeight: _lineHeight,
      );
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF作成中にエラーが発生しました: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('歌詞カード　編集'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            label: const Text('PDF保存・印刷', style: TextStyle(color: Colors.white)),
            onPressed: _isGenerating ? null : _generatePdf,
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            // 左：設定パネル
            Container(
              width: 200,
              color: AppColors.surface,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '設定',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 向き
                  const Text('用紙の向き', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  _ToggleChip(
                    label: '縦（たて）',
                    selected: !_landscape,
                    onTap: () => setState(() => _landscape = false),
                  ),
                  const SizedBox(height: 4),
                  _ToggleChip(
                    label: '横（よこ）',
                    selected: _landscape,
                    onTap: () => setState(() => _landscape = true),
                  ),

                  const SizedBox(height: 20),
                  const Text('文字の大きさ', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  ...[20, 24, 28, 32].map((size) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: _ToggleChip(
                          label: '$size pt',
                          selected: _fontSize == size,
                          onTap: () => setState(() => _fontSize = size),
                        ),
                      )),

                  const SizedBox(height: 20),
                  const Text('行間', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  ...[1.6, 2.0, 2.4].map((lh) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: _ToggleChip(
                          label: lh == 1.6 ? 'ふつう' : lh == 2.0 ? 'ゆったり' : 'とても広め',
                          selected: _lineHeight == lh,
                          onTap: () => setState(() => _lineHeight = lh),
                        ),
                      )),
                ],
              ),
            ),

            // 右：プレビュー・編集エリア
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // 編集中の注意書き
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        border: Border.all(color: Colors.amber.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.edit_note, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Text(
                            '自動生成しました。下のテキストは自由に修正できます。',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // タイトル編集
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: '曲のタイトル',
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(fontSize: _fontSize + 4.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // 歌詞編集
                    TextField(
                      controller: _bodyController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: '歌詞',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      style: TextStyle(
                        fontSize: _fontSize.toDouble(),
                        height: _lineHeight,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // PDF保存ボタン
                    ElevatedButton.icon(
                      icon: _isGenerating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.picture_as_pdf),
                      label: Text(_isGenerating ? 'PDF作成中...' : 'PDF保存・印刷する'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lyricColor,
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      onPressed: _isGenerating ? null : _generatePdf,
                    ),
                  ],
                ),
              ),
            ),
          ],
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

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
