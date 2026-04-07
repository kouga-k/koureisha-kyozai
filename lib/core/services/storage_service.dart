import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';

// Web・非Web共用のシンプルなインメモリ保存サービス
// Windows版ではファイル保存も追加予定
class StorageService {
  // メモリ内キャッシュ（起動中は保持）
  final Map<String, Project> _cache = {};

  // プロジェクト一覧取得（更新日時降順）
  Future<List<Project>> getAllProjects() async {
    if (!kIsWeb) {
      await _loadFromFiles();
    }
    final list = _cache.values.toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  // プロジェクト保存
  Future<void> saveProject(Project project) async {
    project.updatedAt = DateTime.now();
    _cache[project.id] = project;
    if (!kIsWeb) {
      await _saveToFile(project);
    }
  }

  // プロジェクト削除
  Future<void> deleteProject(String id) async {
    _cache.remove(id);
    if (!kIsWeb) {
      await _deleteFile(id);
    }
  }

  // プロジェクト取得
  Future<Project?> getProject(String id) async {
    return _cache[id];
  }

  // --- ネイティブ（非Web）ファイル操作 ---
  Future<void> _loadFromFiles() async {
    try {
      // dart:io を条件コンパイルで使用
      await _loadFromFilesImpl();
    } catch (_) {}
  }

  Future<void> _loadFromFilesImpl() async {
    // ignore: avoid_dynamic_calls
    final io = await _getIo();
    if (io == null) return;
    final dir = io['dir'] as dynamic;
    final files = (dir.listSync() as List).where((f) {
      return f.runtimeType.toString().contains('File') &&
          (f.path as String).endsWith('.json');
    });
    for (final file in files) {
      try {
        final content = await (file as dynamic).readAsString() as String;
        final json = jsonDecode(content) as Map<String, dynamic>;
        final project = Project.fromJson(json);
        _cache[project.id] = project;
      } catch (_) {}
    }
  }

  Future<void> _saveToFile(Project project) async {
    try {
      final io = await _getIo();
      if (io == null) return;
      final dirPath = io['dirPath'] as String;
      final path = io['pathJoin'] as String Function(String, String);
      final fileClass = io['file'] as dynamic Function(String);
      final file = fileClass(path(dirPath, '${project.id}.json'));
      await (file as dynamic).writeAsString(jsonEncode(project.toJson()));
    } catch (_) {}
  }

  Future<void> _deleteFile(String id) async {
    try {
      final io = await _getIo();
      if (io == null) return;
      final dirPath = io['dirPath'] as String;
      final path = io['pathJoin'] as String Function(String, String);
      final fileClass = io['file'] as dynamic Function(String);
      final file = fileClass(path(dirPath, '$id.json'));
      if (await (file as dynamic).exists() as bool) {
        await (file as dynamic).delete();
      }
    } catch (_) {}
  }

  Future<Map<String, dynamic>?> _getIo() async {
    // Web環境ではファイルI/O不可
    if (kIsWeb) return null;
    return null; // Windows版では別途実装
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final allProjectsProvider = FutureProvider<List<Project>>((ref) async {
  final service = ref.read(storageServiceProvider);
  return await service.getAllProjects();
});
