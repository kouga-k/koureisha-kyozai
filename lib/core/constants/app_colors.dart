import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // 基本色（高齢者向け：白背景・黒文字・高コントラスト）
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color primary = Color(0xFF1565C0);      // 見やすい深い青
  static const Color primaryLight = Color(0xFFE3F2FD);
  static const Color accent = Color(0xFF2E7D32);       // 緑（アクション）
  static const Color danger = Color(0xFFC62828);       // 赤（削除・警告）
  static const Color warning = Color(0xFFE65100);      // オレンジ（注意）

  // テキスト色
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ボーダー
  static const Color border = Color(0xFFBDBDBD);
  static const Color divider = Color(0xFFE0E0E0);

  // 機能別カラー
  static const Color coloringColor = Color(0xFF6A1B9A);   // 紫：ぬりえ
  static const Color mistakeColor = Color(0xFF00695C);    // 緑：間違い探し
  static const Color calcColor = Color(0xFF1565C0);       // 青：計算
  static const Color wordColor = Color(0xFF4527A0);       // 紺：言葉
  static const Color reminColor = Color(0xFF6D4C41);      // 茶：回想法
  static const Color lyricColor = Color(0xFF880E4F);      // ピンク：歌詞
}
