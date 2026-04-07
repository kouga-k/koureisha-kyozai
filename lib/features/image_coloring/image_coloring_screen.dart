import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'image_coloring_service.dart';

class ImageColoringScreen extends StatefulWidget {
  const ImageColoringScreen({super.key});

  @override
  State<ImageColoringScreen> createState() => _ImageColoringScreenState();
}

class _ImageColoringScreenState extends State<ImageColoringScreen> {
  Uint8List? _originalBytes;
  Uint8List? _processedBytes;
  String? _fileName;
  bool _isPdf = false;
  bool _isProcessing = false;
  double _sensitivity = 0.5;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'pdf'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final ext = (file.extension ?? '').toLowerCase();
    final bytes = file.bytes;
    if (bytes == null) return;

    setState(() {
      _fileName = file.name;
      _isPdf = ext == 'pdf';
      _processedBytes = null;
    });

    if (_isPdf) {
      setState(() => _isProcessing = true);
      final imageBytes = await ImageColoringService.renderPdfToImageBytes(bytes);
      setState(() {
        _isProcessing = false;
        _originalBytes = imageBytes;
      });
      if (imageBytes == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDFの読み込みに失敗しました。インターネット接続を確認してください。'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      setState(() => _originalBytes = bytes);
    }
  }

  Future<void> _processImage() async {
    if (_originalBytes == null) return;
    setState(() {
      _isProcessing = true;
      _processedBytes = null;
    });

    try {
      final result = await ImageColoringService.processToColoringPage(
        _originalBytes!,
        sensitivity: _sensitivity,
      );
      setState(() => _processedBytes = result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('変換エラー: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _savePdf() async {
    if (_processedBytes == null) return;
    final title = (_fileName ?? '\u306c\u308a\u3048').replaceAll(RegExp(r'\.[^.]+$'), '');
    try {
      await ImageColoringService.saveToPdf(_processedBytes!, '$title\u306c\u308a\u3048');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF\u4fdd\u5b58\u30a8\u30e9\u30fc: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('\u5199\u771f\u30fbPDF\u304b\u3089\u306c\u308a\u3048\u3092\u4f5c\u308b')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 説明
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.deepPurple, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '\u5199\u771f\u3084PDF\u3092\u8f2a\u90ed\u7dda\u306e\u307f\u306e\u306c\u308a\u3048\u306b\u5909\u63db\u3057\u307e\u3059\u3002\nJPG\u30fbPNG\u30fbPDF\u306b\u5bfe\u5fdc\u3057\u3066\u3044\u307e\u3059\u3002',
                        style: TextStyle(fontSize: 14, color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // STEP 1: ファイル選択
              _buildStepHeader(1, '\u30d5\u30a1\u30a4\u30eb\u3092\u9078\u3076'),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.add_photo_alternate, size: 26),
                label: const Text(
                  '\u5199\u771f\u30fbPDF\u3092\u9078\u3076',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 60),
                ),
                onPressed: _isProcessing ? null : _pickFile,
              ),
              if (_fileName != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      _isPdf ? Icons.picture_as_pdf : Icons.image,
                      color: Colors.deepPurple,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _fileName!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (_isProcessing && _originalBytes == null) ...[
                const SizedBox(height: 16),
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: Colors.deepPurple),
                      SizedBox(height: 8),
                      Text('PDF\u3092\u8aad\u307f\u8fbc\u3093\u3067\u3044\u307e\u3059...'),
                    ],
                  ),
                ),
              ],
              if (_originalBytes != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    _originalBytes!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ],

              // STEP 2: 感度調整
              if (_originalBytes != null) ...[
                const SizedBox(height: 24),
                _buildStepHeader(2, '\u7dda\u306e\u7d30\u304b\u3055\u3092\u8abf\u6574'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('\u30b7\u30f3\u30d7\u30eb', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    Expanded(
                      child: Slider(
                        value: _sensitivity,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        activeColor: Colors.deepPurple,
                        onChanged: _isProcessing
                            ? null
                            : (v) => setState(() => _sensitivity = v),
                      ),
                    ),
                    const Text('\u8a73\u7d30', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '\u7dda\u306e\u591a\u3055: ${(_sensitivity * 10).round()} / 10',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),

                // 変換ボタン
                ElevatedButton.icon(
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.brush, size: 26),
                  label: Text(
                    _isProcessing ? '\u5909\u63db\u4e2d...' : '\u306c\u308a\u3048\u306b\u5909\u63db\u3059\u308b',
                    style: const TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: _isProcessing ? null : _processImage,
                ),
                if (_isProcessing)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '\u5927\u304d\u3044\u5199\u771f\u306f\u5c11\u3057\u6642\u9593\u304c\u304b\u304b\u308a\u307e\u3059...',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ),
              ],

              // STEP 3: 結果
              if (_processedBytes != null) ...[
                const SizedBox(height: 24),
                _buildStepHeader(3, '\u5909\u63db\u7d50\u679c'),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.memory(
                      _processedBytes!,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf, size: 26),
                  label: const Text(
                    'PDF\u3067\u4fdd\u5b58\u30fb\u5370\u5237\u3059\u308b',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coloringColor,
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: _savePdf,
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepHeader(int step, String title) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$step',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
