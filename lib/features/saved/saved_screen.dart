import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/project.dart';
import '../../core/services/storage_service.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(allProjectsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('保存済み教材')),
      body: projectsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('読み込みエラー: $e')),
        data: (projects) {
          if (projects.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 80, color: AppColors.textHint),
                  SizedBox(height: 16),
                  Text(
                    'まだ保存された教材がありません',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ホームから教材を作ってください',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final project = projects[index];
              return _ProjectCard(
                project: project,
                onDelete: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('削除の確認'),
                      content: Text('「${project.title}」を削除しますか？'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('キャンセル'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.danger),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('削除'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    await ref.read(storageServiceProvider).deleteProject(project.id);
                    ref.invalidate(allProjectsProvider);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onDelete;

  const _ProjectCard({required this.project, required this.onDelete});

  IconData get _typeIcon {
    switch (project.type) {
      case ProjectType.lyricCard:
        return Icons.music_note;
      case ProjectType.calculation:
        return Icons.calculate;
      case ProjectType.wordQuiz:
        return Icons.spellcheck;
      case ProjectType.reminiscence:
        return Icons.photo_album;
      case ProjectType.coloring:
        return Icons.brush;
      case ProjectType.mistakeFinding:
        return Icons.search;
    }
  }

  Color get _typeColor {
    switch (project.type) {
      case ProjectType.lyricCard:
        return AppColors.lyricColor;
      case ProjectType.calculation:
        return AppColors.calcColor;
      case ProjectType.wordQuiz:
        return AppColors.wordColor;
      case ProjectType.reminiscence:
        return AppColors.reminColor;
      case ProjectType.coloring:
        return AppColors.coloringColor;
      case ProjectType.mistakeFinding:
        return AppColors.mistakeColor;
    }
  }

  String get _typeLabel {
    switch (project.type) {
      case ProjectType.lyricCard:
        return '歌詞カード';
      case ProjectType.calculation:
        return '計算問題';
      case ProjectType.wordQuiz:
        return '言葉問題';
      case ProjectType.reminiscence:
        return '回想法カード';
      case ProjectType.coloring:
        return 'ぬりえ';
      case ProjectType.mistakeFinding:
        return '間違い探し';
    }
  }

  @override
  Widget build(BuildContext context) {
    final updatedAt = project.updatedAt;
    final dateStr =
        '${updatedAt.year}/${updatedAt.month}/${updatedAt.day} ${updatedAt.hour}:${updatedAt.minute.toString().padLeft(2, '0')}';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _typeColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(_typeIcon, color: _typeColor),
        ),
        title: Text(
          project.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(_typeLabel,
                style: TextStyle(fontSize: 13, color: _typeColor)),
            Text('更新: $dateStr',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.danger),
          onPressed: onDelete,
          tooltip: '削除',
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('「${project.title}」を開きます（実装予定）')),
          );
        },
      ),
    );
  }
}
