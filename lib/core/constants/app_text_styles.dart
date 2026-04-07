import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // アプリUI用（操作画面）
  static const TextStyle appTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle appSubtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle appBody = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const TextStyle appCaption = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnPrimary,
  );

  // 教材出力用（A4印刷）
  static const TextStyle materialTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle materialBody = TextStyle(
    fontSize: 24,
    color: AppColors.textPrimary,
    height: 2.0,
  );

  static const TextStyle materialBodyLarge = TextStyle(
    fontSize: 28,
    color: AppColors.textPrimary,
    height: 2.0,
  );

  static const TextStyle materialRuby = TextStyle(
    fontSize: 11,
    color: AppColors.textPrimary,
  );
}
