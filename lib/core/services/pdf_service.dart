import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  /// 歌詞カードPDFを生成してプレビューする
  Future<void> generateLyricCardPdf({
    required String title,
    required String body,
    required bool landscape,
    required int fontSize,
    required double lineHeight,
    bool furigana = false,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.notoSansJPRegular();
    final boldFont = await PdfGoogleFonts.notoSansJPBold();

    final pageFormat =
        landscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4;

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(20 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // タイトル
              pw.Text(
                title,
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: (fontSize * 1.4).roundToDouble(),
                ),
              ),
              pw.SizedBox(height: 8 * PdfPageFormat.mm),
              pw.Divider(),
              pw.SizedBox(height: 6 * PdfPageFormat.mm),
              // 本文
              pw.Text(
                body,
                style: pw.TextStyle(
                  font: font,
                  fontSize: fontSize.toDouble(),
                  lineSpacing: fontSize * (lineHeight - 1.0),
                ),
              ),
            ],
          );
        },
      ),
    );

    await _previewPdfDoc(pdf, 'lyric_card');
  }

  /// 計算問題PDFを生成してプレビューする
  Future<void> generateCalculationPdf({
    required String title,
    required List<String> questions,
    required int fontSize,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.notoSansJPRegular();
    final boldFont = await PdfGoogleFonts.notoSansJPBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(font: boldFont, fontSize: 28),
              ),
              pw.SizedBox(height: 10 * PdfPageFormat.mm),
              // 問題リスト
              ...questions.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final q = entry.value;
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8 * PdfPageFormat.mm),
                  child: pw.Row(
                    children: [
                      pw.SizedBox(
                        width: 12 * PdfPageFormat.mm,
                        child: pw.Text(
                          '($index)',
                          style: pw.TextStyle(font: font, fontSize: fontSize.toDouble()),
                        ),
                      ),
                      pw.Text(
                        q,
                        style: pw.TextStyle(font: font, fontSize: fontSize.toDouble()),
                      ),
                      pw.SizedBox(width: 10 * PdfPageFormat.mm),
                      pw.Text(
                        '答え：＿＿＿＿',
                        style: pw.TextStyle(font: font, fontSize: fontSize.toDouble()),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );

    await _previewPdfDoc(pdf, 'calculation');
  }

  /// PDF生成してブラウザ印刷ダイアログを開く（Web・Windows両対応）
  Future<void> _previewPdfDoc(pw.Document pdf, String prefix) async {
    final bytes = await pdf.save();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await Printing.sharePdf(
      bytes: bytes,
      filename: '${prefix}_$timestamp.pdf',
    );
  }
}

// シングルトン
final pdfService = PdfService();
