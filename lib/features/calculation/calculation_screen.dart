import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/pdf_service.dart';

enum CalcType { addition, subtraction, multiplication, money }

class CalculationScreen extends StatefulWidget {
  const CalculationScreen({super.key});

  @override
  State<CalculationScreen> createState() => _CalculationScreenState();
}

class _CalculationScreenState extends State<CalculationScreen> {
  CalcType _calcType = CalcType.addition;
  int _digits = 1; // 1桁 or 2桁
  int _count = 10; // 問題数
  bool _carryOver = false; // 繰り上がり
  List<String> _questions = [];
  String _title = '';
  bool _isGenerating = false;

  void _generate() {
    final questions = <String>[];
    final rand = Random();

    for (int i = 0; i < _count; i++) {
      questions.add(_makeQuestion(rand));
    }

    String titlePrefix;
    switch (_calcType) {
      case CalcType.addition:
        titlePrefix = '足し算';
        break;
      case CalcType.subtraction:
        titlePrefix = '引き算';
        break;
      case CalcType.multiplication:
        titlePrefix = '掛け算';
        break;
      case CalcType.money:
        titlePrefix = 'お金の計算';
        break;
    }

    setState(() {
      _questions = questions;
      _title = '$titlePrefix の問題';
    });
  }

  String _makeQuestion(Random rand) {
    final max = _digits == 1 ? 9 : 99;
    switch (_calcType) {
      case CalcType.addition:
        if (_carryOver) {
          // 繰り上がりあり：合計が桁を超えるような数
          final a = rand.nextInt(max ~/ 2) + max ~/ 2;
          final b = rand.nextInt(max - a + 1) + (max - a);
          return '$a ＋ $b ＝';
        } else {
          final a = rand.nextInt(max) + 1;
          final b = rand.nextInt(max - a + 1) + 1;
          return '$a ＋ $b ＝';
        }
      case CalcType.subtraction:
        final a = rand.nextInt(max) + 1;
        final b = rand.nextInt(a) + 1;
        return '$a － $b ＝';
      case CalcType.multiplication:
        final a = rand.nextInt(9) + 1;
        final b = rand.nextInt(9) + 1;
        return '$a × $b ＝';
      case CalcType.money:
        final prices = [10, 20, 30, 50, 80, 100, 150, 200, 300, 500];
        final a = prices[rand.nextInt(prices.length)];
        final b = prices[rand.nextInt(prices.length)];
        return '$a円 ＋ $b円 ＝       円';
    }
  }

  Future<void> _savePdf() async {
    setState(() => _isGenerating = true);
    try {
      await pdfService.generateCalculationPdf(
        title: _title,
        questions: _questions,
        fontSize: 24,
      );
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('エラー: $e'),
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
      appBar: AppBar(title: const Text('計算問題を作る')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 計算の種類
              const Text('計算の種類',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  _CalcChip(
                    label: '足し算 ＋',
                    selected: _calcType == CalcType.addition,
                    onTap: () => setState(() => _calcType = CalcType.addition),
                  ),
                  _CalcChip(
                    label: '引き算 －',
                    selected: _calcType == CalcType.subtraction,
                    onTap: () => setState(() => _calcType = CalcType.subtraction),
                  ),
                  _CalcChip(
                    label: '掛け算 ×',
                    selected: _calcType == CalcType.multiplication,
                    onTap: () => setState(() => _calcType = CalcType.multiplication),
                  ),
                  _CalcChip(
                    label: 'お金の計算 💴',
                    selected: _calcType == CalcType.money,
                    onTap: () => setState(() => _calcType = CalcType.money),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 桁数（お金以外）
              if (_calcType != CalcType.money && _calcType != CalcType.multiplication) ...[
                const Text('数字の大きさ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    _CalcChip(
                      label: '１桁（1〜9）',
                      selected: _digits == 1,
                      onTap: () => setState(() => _digits = 1),
                    ),
                    _CalcChip(
                      label: '２桁（10〜99）',
                      selected: _digits == 2,
                      onTap: () => setState(() => _digits = 2),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 繰り上がり
                Row(
                  children: [
                    Switch(
                      value: _carryOver,
                      onChanged: (v) => setState(() => _carryOver = v),
                    ),
                    const SizedBox(width: 8),
                    const Text('繰り上がり・繰り下がりあり',
                        style: TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // 問題数
              const Text('問題の数',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [5, 10, 15, 20].map((n) => _CalcChip(
                      label: '$n問',
                      selected: _count == n,
                      onTap: () => setState(() => _count = n),
                    )).toList(),
              ),
              const SizedBox(height: 24),

              // 生成ボタン
              ElevatedButton.icon(
                icon: const Icon(Icons.auto_awesome),
                label: const Text('問題を作る'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.calcColor),
                onPressed: _generate,
              ),

              // 生成された問題プレビュー
              if (_questions.isNotEmpty) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('作り直す'),
                      onPressed: _generate,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.surface,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _questions.asMap().entries.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            '(${e.key + 1})  ${e.value}',
                            style: const TextStyle(fontSize: 20, height: 1.8),
                          ),
                        )).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.picture_as_pdf),
                  label: Text(_isGenerating ? 'PDF作成中...' : 'PDF保存・印刷する'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.calcColor),
                  onPressed: _isGenerating ? null : _savePdf,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CalcChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CalcChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.calcColor : Colors.white,
          border: Border.all(
            color: selected ? AppColors.calcColor : AppColors.border,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
