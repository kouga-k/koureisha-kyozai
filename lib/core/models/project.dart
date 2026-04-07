import 'dart:convert';

enum ProjectType {
  lyricCard,
  calculation,
  wordQuiz,
  reminiscence,
  coloring,
  mistakeFinding,
}

enum SourceType {
  keyword,
  text,
  photo,
  pdf,
  template,
}

class Project {
  final String id;
  String title;
  ProjectType type;
  SourceType sourceType;
  DateTime createdAt;
  DateTime updatedAt;
  String? thumbnailPath;
  String? theme;
  List<ProjectPage> pages;

  Project({
    required this.id,
    required this.title,
    required this.type,
    required this.sourceType,
    required this.createdAt,
    required this.updatedAt,
    this.thumbnailPath,
    this.theme,
    List<ProjectPage>? pages,
  }) : pages = pages ?? [];

  factory Project.create({
    required String title,
    required ProjectType type,
    SourceType sourceType = SourceType.keyword,
    String? theme,
  }) {
    final now = DateTime.now();
    return Project(
      id: now.millisecondsSinceEpoch.toString(),
      title: title,
      type: type,
      sourceType: sourceType,
      createdAt: now,
      updatedAt: now,
      theme: theme,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.index,
        'sourceType': sourceType.index,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'thumbnailPath': thumbnailPath,
        'theme': theme,
        'pages': pages.map((p) => p.toJson()).toList(),
      };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] as String,
        title: json['title'] as String,
        type: ProjectType.values[json['type'] as int],
        sourceType: SourceType.values[json['sourceType'] as int],
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        thumbnailPath: json['thumbnailPath'] as String?,
        theme: json['theme'] as String?,
        pages: (json['pages'] as List<dynamic>? ?? [])
            .map((p) => ProjectPage.fromJson(p as Map<String, dynamic>))
            .toList(),
      );
}

class ProjectPage {
  final String id;
  int pageNumber;
  String pageType;
  String? title;
  String? body;
  String? imagePath;
  int fontSize;
  double lineHeight;
  bool furiganaEnabled;
  String orientation;
  int marginMm;

  ProjectPage({
    required this.id,
    required this.pageNumber,
    required this.pageType,
    this.title,
    this.body,
    this.imagePath,
    this.fontSize = 24,
    this.lineHeight = 2.0,
    this.furiganaEnabled = true,
    this.orientation = 'portrait',
    this.marginMm = 15,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'pageNumber': pageNumber,
        'pageType': pageType,
        'title': title,
        'body': body,
        'imagePath': imagePath,
        'fontSize': fontSize,
        'lineHeight': lineHeight,
        'furiganaEnabled': furiganaEnabled,
        'orientation': orientation,
        'marginMm': marginMm,
      };

  factory ProjectPage.fromJson(Map<String, dynamic> json) => ProjectPage(
        id: json['id'] as String,
        pageNumber: json['pageNumber'] as int,
        pageType: json['pageType'] as String,
        title: json['title'] as String?,
        body: json['body'] as String?,
        imagePath: json['imagePath'] as String?,
        fontSize: json['fontSize'] as int? ?? 24,
        lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 2.0,
        furiganaEnabled: json['furiganaEnabled'] as bool? ?? true,
        orientation: json['orientation'] as String? ?? 'portrait',
        marginMm: json['marginMm'] as int? ?? 15,
      );
}
