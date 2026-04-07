import 'dart:js_interop';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

@JS('renderPdfFirstPage')
external JSPromise<JSUint8Array> _jsPdfRender(JSUint8Array data);

class ImageColoringService {
  /// PDFの1ページ目を画像バイト（PNG）として取得する
  static Future<Uint8List?> renderPdfToImageBytes(Uint8List pdfBytes) async {
    try {
      final result = await _jsPdfRender(pdfBytes.toJS).toDart;
      return result.toDart;
    } catch (e) {
      return null;
    }
  }

  /// 画像バイトをぬりえ用（白地に黒い輪郭線）に変換してPNGで返す
  /// sensitivity: 0.0 = シンプル（線が少ない）〜 1.0 = 詳細（線が多い）
  static Future<Uint8List> processToColoringPage(
    Uint8List inputBytes, {
    double sensitivity = 0.5,
  }) async {
    final original = img.decodeImage(inputBytes);
    if (original == null) throw Exception('画像を読み込めませんでした');

    img.Image work = original;

    // 大きすぎる場合はリサイズ（処理速度のため）
    if (work.width > 1000) {
      work = img.copyResize(
        work,
        width: 1000,
        interpolation: img.Interpolation.linear,
      );
    }

    // グレースケール変換
    work = img.grayscale(work);

    // ガウシアンブラーでノイズを軽減
    work = img.gaussianBlur(work, radius: 2);

    // Sobelエッジ検出（エッジが明るく、背景が暗い）
    work = img.sobel(work);

    // sensitivity: 0.0 → threshold=80（線が少ない）, 1.0 → threshold=20（線が多い）
    final threshold = (80 - sensitivity * 60).round().clamp(10, 90);

    // 二値化：エッジ（明るい）→ 黒、背景（暗い）→ 白
    for (final pixel in work) {
      if (pixel.r > threshold) {
        pixel.r = 0;
        pixel.g = 0;
        pixel.b = 0;
      } else {
        pixel.r = 255;
        pixel.g = 255;
        pixel.b = 255;
      }
    }

    return Uint8List.fromList(img.encodePng(work));
  }

  /// 処理済みPNG画像をA4 PDFとして印刷ダイアログに表示する
  static Future<void> saveToPdf(Uint8List pngBytes, String title) async {
    final pdfDoc = pw.Document();
    final memImage = pw.MemoryImage(pngBytes);

    pdfDoc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => pw.Center(
          child: pw.Image(memImage, fit: pw.BoxFit.contain),
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdfDoc.save(),
      name: title,
    );
  }
}
