import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AiColoringService {
  /// Gemini AIにSVG塗り絵を生成させる
  static Future<String?> generateSvg(String theme, String apiKey) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );

    final prompt = '''
あなたはプロのイラストレーターです。日本の高齢者向けぬりえ（塗り絵）の線画をSVGで作成してください。

テーマ: 「$theme」

要件（必ず守ること）:
- SVGタグ: <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400">
- 全要素に: stroke="#1a1a1a" fill="none" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"
- 塗りつぶしは使わない（fill="none"のみ）
- シンプルで大きな図案（細かい模様は入れない）
- 高齢者がぬりやすいデザイン: 線が太め・余白が多め・塗り面積が大きい
- テーマがひと目でわかる特徴を入れる
- 400×400の画面全体を使って大きく描く

SVGコードのみを出力してください（必ず```svgと```で囲むこと）:
''';

    final response = await model.generateContent([Content.text(prompt)]);
    return _extractSvg(response.text ?? '');
  }

  static String? _extractSvg(String text) {
    // ```svg ... ``` または ``` ... ``` ブロック
    final block =
        RegExp(r'```(?:svg|xml)?\s*([\s\S]*?)```', caseSensitive: false)
            .firstMatch(text);
    if (block != null) {
      final code = block.group(1)?.trim() ?? '';
      if (code.contains('<svg')) return code;
    }
    // タグ直接
    final xml =
        RegExp(r'<svg[\s\S]*?</svg>', caseSensitive: false).firstMatch(text);
    return xml?.group(0);
  }

  /// SVG文字列をPNG画像バイトに変換する（ブラウザのCanvas使用）
  static Future<Uint8List> svgToPng(String svgContent) async {
    const width = 800;
    const height = 800;

    // viewBox がなければ追加する
    String svg = svgContent;
    if (!svg.contains('viewBox') && !svg.contains('width=')) {
      svg = svg.replaceFirst('<svg', '<svg width="400" height="400"');
    }

    final blob = html.Blob([svg], 'image/svg+xml');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final completer = Completer<void>();
    final img = html.ImageElement();
    img.onLoad.listen((_) => completer.complete());
    img.onError
        .listen((_) => completer.completeError(Exception('SVG読み込み失敗')));
    img.src = url;
    await completer.future;

    final canvas = html.CanvasElement(width: width, height: height);
    final ctx = canvas.context2D;
    ctx.fillStyle = '#ffffff';
    ctx.fillRect(0, 0, width, height);
    ctx.drawImageScaled(img, 0, 0, width, height);
    html.Url.revokeObjectUrl(url);

    final dataUrl = canvas.toDataUrl('image/png');
    final base64 = dataUrl.split(',')[1];
    return base64Decode(base64);
  }

  /// PNG画像をA4 PDFとして印刷・保存する
  static Future<void> saveToPdf(Uint8List pngBytes, String title) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (ctx) => pw.Center(
          child: pw.Image(pw.MemoryImage(pngBytes), fit: pw.BoxFit.contain),
        ),
      ),
    );
    await Printing.layoutPdf(
      onLayout: (_) async => doc.save(),
      name: title,
    );
  }
}
