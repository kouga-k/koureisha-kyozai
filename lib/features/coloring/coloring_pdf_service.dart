import 'dart:math' as math;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ColoringPdfService {
  static Future<void> generateColoringPdf({
    required String name,
    required String season,
    required String difficulty,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Text(
                name,
                style: pw.TextStyle(
                    fontSize: 32, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '\u5b63\u7bc0: $season\u3000\u96e3\u6613\u5ea6: $difficulty',
                style: const pw.TextStyle(fontSize: 13),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 12),
              pw.Expanded(
                child: pw.CustomPaint(
                  painter: (canvas, size) {
                    canvas.setStrokeColor(PdfColors.black);
                    canvas.setLineWidth(3.0);
                    _drawShape(canvas, size, name);
                  },
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                '\u81ea\u7531\u306b\u8272\u3092\u306c\u3063\u3066\u307f\u307e\u3057\u3087\u3046\uff01',
                style: const pw.TextStyle(fontSize: 13),
                textAlign: pw.TextAlign.center,
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await Printing.sharePdf(
        bytes: bytes, filename: 'nurie_${name}_$timestamp.pdf');
  }

  static void _drawShape(PdfGraphics canvas, PdfPoint size, String name) {
    // \u685c=桜 \u30c1\u30e5\u30fc\u30ea\u30c3\u30d7=チューリップ
    // \u3072\u307e\u308f\u308a=ひまわり \u671d\u984f=朝顔
    // \u3082\u307f\u3058=もみじ \u3069\u3093\u3050\u308a=どんぐり
    // \u96ea\u3060\u308b\u307e=雪だるま \u5bcc\u58eb\u5c71=富士山
    // \u91d1\u9b5a=金魚 \u3046\u3055\u304e=うさぎ
    // \u732b=猫 \u8776\u3005=蝶々
    if (name == '\u685c') {
      _drawSakura(canvas, size);
    } else if (name == '\u30c1\u30e5\u30fc\u30ea\u30c3\u30d7') {
      _drawTulip(canvas, size);
    } else if (name == '\u3072\u307e\u308f\u308a') {
      _drawSunflower(canvas, size);
    } else if (name == '\u671d\u984f') {
      _drawMorningGlory(canvas, size);
    } else if (name == '\u3082\u307f\u3058') {
      _drawMomiji(canvas, size);
    } else if (name == '\u3069\u3093\u3050\u308a') {
      _drawAcorn(canvas, size);
    } else if (name == '\u96ea\u3060\u308b\u307e') {
      _drawSnowman(canvas, size);
    } else if (name == '\u5bcc\u58eb\u5c71') {
      _drawMtFuji(canvas, size);
    } else if (name == '\u91d1\u9b5a') {
      _drawGoldfish(canvas, size);
    } else if (name == '\u3046\u3055\u304e') {
      _drawRabbit(canvas, size);
    } else if (name == '\u732b') {
      _drawCat(canvas, size);
    } else if (name == '\u8776\u3005') {
      _drawButterfly(canvas, size);
    } else {
      _drawDefault(canvas, size);
    }
  }

  // ── 桜 ───────────────────────────────────────────────────────────────────
  static void _drawSakura(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2 + 50;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);

    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * math.pi) / 5 + math.pi / 2;
      final px = cx + 80 * math.cos(angle);
      final py = cy + 80 * math.sin(angle);
      final ctrlAngle1 = angle - 0.5;
      final ctrlAngle2 = angle + 0.5;

      canvas.moveTo(cx, cy);
      canvas.curveTo(
        cx + 120 * math.cos(ctrlAngle1), cy + 120 * math.sin(ctrlAngle1),
        cx + 150 * math.cos(angle), cy + 150 * math.sin(angle),
        px, py,
      );
      canvas.curveTo(
        cx + 150 * math.cos(angle), cy + 150 * math.sin(angle),
        cx + 120 * math.cos(ctrlAngle2), cy + 120 * math.sin(ctrlAngle2),
        cx, cy,
      );
    }
    canvas.strokePath();

    canvas.setLineWidth(1.5);
    canvas.drawEllipse(cx, cy, 15, 15);
    canvas.strokePath();
  }

  // ── チューリップ ──────────────────────────────────────────────────────────
  static void _drawTulip(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);

    canvas.drawLine(cx, cy - 20, cx, cy - 250);
    canvas.strokePath();

    canvas.moveTo(cx, cy - 150);
    canvas.curveTo(cx + 80, cy - 100, cx + 120, cy + 20, cx + 100, cy + 50);
    canvas.curveTo(cx + 60, cy - 50, cx + 20, cy - 180, cx, cy - 200);
    canvas.moveTo(cx, cy - 120);
    canvas.curveTo(cx - 80, cy - 70, cx - 120, cy + 40, cx - 100, cy + 70);
    canvas.curveTo(cx - 60, cy - 30, cx - 20, cy - 150, cx, cy - 170);
    canvas.strokePath();

    canvas.moveTo(cx - 70, cy);
    canvas.curveTo(cx - 80, cy - 100, cx + 80, cy - 100, cx + 70, cy);
    canvas.lineTo(cx + 40, cy + 80);
    canvas.lineTo(cx, cy + 20);
    canvas.lineTo(cx - 40, cy + 80);
    canvas.lineTo(cx - 70, cy);
    canvas.strokePath();
  }

  // ── ひまわり ──────────────────────────────────────────────────────────────
  static void _drawSunflower(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2 + 80;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);

    canvas.drawLine(cx, cy - 80, cx, cy - 350);
    canvas.strokePath();

    for (int i = 0; i < 12; i++) {
      final angle = (i * 2 * math.pi) / 12;
      final px = cx + 160 * math.cos(angle);
      final py = cy + 160 * math.sin(angle);
      canvas.moveTo(cx + 70 * math.cos(angle - 0.2), cy + 70 * math.sin(angle - 0.2));
      canvas.lineTo(px, py);
      canvas.lineTo(cx + 70 * math.cos(angle + 0.2), cy + 70 * math.sin(angle + 0.2));
    }
    canvas.strokePath();

    canvas.drawEllipse(cx, cy, 80, 80);
    canvas.setFillColor(PdfColors.white);
    canvas.fillPath();
    canvas.drawEllipse(cx, cy, 80, 80);
    canvas.strokePath();

    canvas.setLineWidth(1.5);
    for (int i = -60; i <= 60; i += 20) {
      canvas.drawLine(cx + i, cy - 60, cx + i, cy + 60);
      canvas.drawLine(cx - 60, cy + i, cx + 60, cy + i);
    }
    canvas.strokePath();
  }

  // ── 朝顔 ──────────────────────────────────────────────────────────────────
  static void _drawMorningGlory(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2 + 50;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);

    canvas.drawEllipse(cx, cy, 140, 140);
    canvas.strokePath();

    canvas.setLineWidth(1.5);
    canvas.drawEllipse(cx, cy, 20, 20);
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * math.pi) / 5 + math.pi / 2;
      canvas.drawLine(
        cx + 20 * math.cos(angle), cy + 20 * math.sin(angle),
        cx + 140 * math.cos(angle), cy + 140 * math.sin(angle),
      );
    }
    canvas.strokePath();

    canvas.setLineWidth(3.0);
    canvas.moveTo(cx - 100, cy - 100);
    canvas.curveTo(cx - 150, cy - 250, cx + 50, cy - 150, cx, cy - 300);
    canvas.strokePath();
  }

  // ── もみじ ────────────────────────────────────────────────────────────────
  static void _drawMomiji(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);

    final pts = [
      PdfPoint(cx, cy + 150),
      PdfPoint(cx + 40, cy + 50),
      PdfPoint(cx + 140, cy + 100),
      PdfPoint(cx + 70, cy + 10),
      PdfPoint(cx + 160, cy - 30),
      PdfPoint(cx + 50, cy - 50),
      PdfPoint(cx + 80, cy - 150),
      PdfPoint(cx + 20, cy - 80),
      PdfPoint(cx, cy - 180),
      PdfPoint(cx - 10, cy - 80),
      PdfPoint(cx - 80, cy - 150),
      PdfPoint(cx - 50, cy - 50),
      PdfPoint(cx - 160, cy - 30),
      PdfPoint(cx - 70, cy + 10),
      PdfPoint(cx - 140, cy + 100),
      PdfPoint(cx - 40, cy + 50),
    ];

    canvas.moveTo(pts[0].x, pts[0].y);
    for (int i = 1; i < pts.length; i++) {
      canvas.lineTo(pts[i].x, pts[i].y);
    }
    canvas.closePath();
    canvas.strokePath();

    canvas.setLineWidth(1.5);
    canvas.drawLine(cx, cy - 80, cx, cy + 150);
    canvas.drawLine(cx, cy - 80, cx + 140, cy + 100);
    canvas.drawLine(cx, cy - 80, cx - 140, cy + 100);
    canvas.strokePath();
  }

  // ── どんぐり ──────────────────────────────────────────────────────────────
  static void _drawAcorn(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);

    canvas.drawEllipse(cx, cy - 50, 90, 110);
    canvas.strokePath();

    canvas.setFillColor(PdfColors.white);
    canvas.moveTo(cx - 110, cy + 20);
    canvas.curveTo(cx - 110, cy + 100, cx + 110, cy + 100, cx + 110, cy + 20);
    canvas.lineTo(cx - 110, cy + 20);
    canvas.fillPath();
    canvas.moveTo(cx - 110, cy + 20);
    canvas.curveTo(cx - 110, cy + 100, cx + 110, cy + 100, cx + 110, cy + 20);
    canvas.lineTo(cx - 110, cy + 20);
    canvas.strokePath();

    canvas.setLineWidth(1.5);
    for (int i = -80; i <= 80; i += 20) {
      canvas.drawLine(cx + i, cy + 20, cx + i + 20, cy + 80);
      canvas.drawLine(cx + i, cy + 80, cx + i + 20, cy + 20);
    }
    canvas.strokePath();
  }

  // ── 雪だるま ──────────────────────────────────────────────────────────────
  static void _drawSnowman(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);

    canvas.drawEllipse(cx, cy - 100, 120, 120);
    canvas.strokePath();

    canvas.setFillColor(PdfColors.white);
    canvas.drawEllipse(cx, cy + 80, 80, 80);
    canvas.fillPath();
    canvas.drawEllipse(cx, cy + 80, 80, 80);
    canvas.strokePath();

    canvas.setFillColor(PdfColors.black);
    canvas.drawEllipse(cx - 30, cy + 100, 8, 8);
    canvas.drawEllipse(cx + 30, cy + 100, 8, 8);
    canvas.fillPath();

    canvas.moveTo(cx, cy + 80);
    canvas.lineTo(cx + 40, cy + 70);
    canvas.lineTo(cx, cy + 60);
    canvas.closePath();
    canvas.strokePath();

    canvas.setFillColor(PdfColors.white);
    canvas.moveTo(cx - 50, cy + 150);
    canvas.lineTo(cx - 40, cy + 220);
    canvas.lineTo(cx + 40, cy + 220);
    canvas.lineTo(cx + 50, cy + 150);
    canvas.closePath();
    canvas.fillPath();
    canvas.moveTo(cx - 50, cy + 150);
    canvas.lineTo(cx - 40, cy + 220);
    canvas.lineTo(cx + 40, cy + 220);
    canvas.lineTo(cx + 50, cy + 150);
    canvas.closePath();
    canvas.strokePath();

    canvas.drawLine(cx - 110, cy, cx - 180, cy + 50);
    canvas.drawLine(cx + 110, cy, cx + 180, cy + 50);
    canvas.strokePath();
  }

  // ── 富士山 ────────────────────────────────────────────────────────────────
  static void _drawMtFuji(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2 - 50;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);

    canvas.drawEllipse(cx, cy + 150, 80, 80);
    canvas.strokePath();

    canvas.setFillColor(PdfColors.white);
    canvas.moveTo(cx - 220, cy - 100);
    canvas.curveTo(cx - 100, cy - 20, cx - 50, cy + 120, cx - 40, cy + 140);
    canvas.lineTo(cx + 40, cy + 140);
    canvas.curveTo(cx + 50, cy + 120, cx + 100, cy - 20, cx + 220, cy - 100);
    canvas.closePath();
    canvas.fillPath();

    canvas.moveTo(cx - 220, cy - 100);
    canvas.curveTo(cx - 100, cy - 20, cx - 50, cy + 120, cx - 40, cy + 140);
    canvas.lineTo(cx + 40, cy + 140);
    canvas.curveTo(cx + 50, cy + 120, cx + 100, cy - 20, cx + 220, cy - 100);
    canvas.lineTo(cx - 220, cy - 100);
    canvas.strokePath();

    canvas.moveTo(cx - 75, cy + 60);
    canvas.lineTo(cx - 40, cy + 30);
    canvas.lineTo(cx, cy + 70);
    canvas.lineTo(cx + 40, cy + 30);
    canvas.lineTo(cx + 75, cy + 60);
    canvas.strokePath();
  }

  // ── 金魚 ──────────────────────────────────────────────────────────────────
  static void _drawGoldfish(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);

    canvas.moveTo(cx - 100, cy);
    canvas.curveTo(cx - 100, cy + 100, cx + 50, cy + 80, cx + 80, cy);
    canvas.curveTo(cx + 50, cy - 80, cx - 100, cy - 100, cx - 100, cy);
    canvas.strokePath();

    canvas.moveTo(cx - 100, cy);
    canvas.curveTo(cx - 180, cy + 120, cx - 250, cy + 50, cx - 200, cy);
    canvas.curveTo(cx - 250, cy - 50, cx - 180, cy - 120, cx - 100, cy);
    canvas.strokePath();

    canvas.drawEllipse(cx + 40, cy + 20, 15, 15);
    canvas.strokePath();
    canvas.setFillColor(PdfColors.black);
    canvas.drawEllipse(cx + 45, cy + 20, 5, 5);
    canvas.fillPath();

    canvas.moveTo(cx - 20, cy - 50);
    canvas.curveTo(cx - 50, cy - 100, cx - 10, cy - 120, cx + 10, cy - 70);
    canvas.strokePath();
  }

  // ── うさぎ ────────────────────────────────────────────────────────────────
  static void _drawRabbit(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);

    canvas.drawEllipse(cx - 30, cy + 120, 25, 80);
    canvas.drawEllipse(cx + 30, cy + 120, 25, 80);
    canvas.strokePath();

    canvas.setLineWidth(1.5);
    canvas.drawEllipse(cx - 30, cy + 120, 10, 50);
    canvas.drawEllipse(cx + 30, cy + 120, 10, 50);
    canvas.strokePath();

    canvas.setLineWidth(3.0);
    canvas.setFillColor(PdfColors.white);
    canvas.drawEllipse(cx, cy, 100, 80);
    canvas.fillPath();
    canvas.drawEllipse(cx, cy, 100, 80);
    canvas.strokePath();

    canvas.setFillColor(PdfColors.black);
    canvas.drawEllipse(cx - 40, cy + 10, 8, 12);
    canvas.drawEllipse(cx + 40, cy + 10, 8, 12);
    canvas.fillPath();

    canvas.drawEllipse(cx, cy - 10, 5, 5);
    canvas.fillPath();
    canvas.moveTo(cx, cy - 15);
    canvas.curveTo(cx, cy - 30, cx - 20, cy - 30, cx - 20, cy - 20);
    canvas.moveTo(cx, cy - 15);
    canvas.curveTo(cx, cy - 30, cx + 20, cy - 30, cx + 20, cy - 20);
    canvas.strokePath();
  }

  // ── 猫 ───────────────────────────────────────────────────────────────────
  static void _drawCat(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);

    canvas.moveTo(cx - 80, cy + 40);
    canvas.lineTo(cx - 90, cy + 130);
    canvas.lineTo(cx - 20, cy + 80);
    canvas.moveTo(cx + 80, cy + 40);
    canvas.lineTo(cx + 90, cy + 130);
    canvas.lineTo(cx + 20, cy + 80);
    canvas.strokePath();

    canvas.setFillColor(PdfColors.white);
    canvas.drawEllipse(cx, cy, 110, 90);
    canvas.fillPath();
    canvas.drawEllipse(cx, cy, 110, 90);
    canvas.strokePath();

    canvas.drawEllipse(cx - 40, cy + 10, 15, 15);
    canvas.drawEllipse(cx + 40, cy + 10, 15, 15);
    canvas.strokePath();
    canvas.setFillColor(PdfColors.black);
    canvas.drawEllipse(cx - 40, cy + 10, 5, 10);
    canvas.drawEllipse(cx + 40, cy + 10, 5, 10);
    canvas.fillPath();

    canvas.setLineWidth(1.5);
    canvas.drawLine(cx - 140, cy - 10, cx - 60, cy - 20);
    canvas.drawLine(cx - 150, cy - 30, cx - 60, cy - 30);
    canvas.drawLine(cx - 140, cy - 50, cx - 60, cy - 40);
    canvas.drawLine(cx + 140, cy - 10, cx + 60, cy - 20);
    canvas.drawLine(cx + 150, cy - 30, cx + 60, cy - 30);
    canvas.drawLine(cx + 140, cy - 50, cx + 60, cy - 40);
    canvas.strokePath();
  }

  // ── 蝶々 ──────────────────────────────────────────────────────────────────
  static void _drawButterfly(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);

    canvas.moveTo(cx, cy);
    canvas.curveTo(cx - 100, cy + 200, cx - 250, cy + 50, cx, cy - 50);
    canvas.moveTo(cx, cy);
    canvas.curveTo(cx + 100, cy + 200, cx + 250, cy + 50, cx, cy - 50);
    canvas.strokePath();

    canvas.moveTo(cx, cy - 20);
    canvas.curveTo(cx - 150, cy - 50, cx - 100, cy - 200, cx, cy - 100);
    canvas.moveTo(cx, cy - 20);
    canvas.curveTo(cx + 150, cy - 50, cx + 100, cy - 200, cx, cy - 100);
    canvas.strokePath();

    canvas.setFillColor(PdfColors.white);
    canvas.drawEllipse(cx, cy - 30, 15, 60);
    canvas.fillPath();
    canvas.drawEllipse(cx, cy - 30, 15, 60);
    canvas.strokePath();

    canvas.setLineWidth(1.5);
    canvas.moveTo(cx - 5, cy + 30);
    canvas.curveTo(cx - 20, cy + 80, cx - 50, cy + 80, cx - 40, cy + 100);
    canvas.moveTo(cx + 5, cy + 30);
    canvas.curveTo(cx + 20, cy + 80, cx + 50, cy + 80, cx + 40, cy + 100);
    canvas.strokePath();
  }

  // ── デフォルト ────────────────────────────────────────────────────────────
  static void _drawDefault(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.drawRect(20, 20, size.x - 40, size.y - 40);
    canvas.strokePath();
    for (var i = 0; i < 6; i++) {
      final a = i * math.pi / 3;
      canvas.drawEllipse(cx + 80 * math.cos(a), cy + 80 * math.sin(a), 60, 60);
      canvas.strokePath();
    }
    canvas.setFillColor(PdfColors.white);
    canvas.drawEllipse(cx, cy, 55, 55);
    canvas.fillPath();
    canvas.drawEllipse(cx, cy, 55, 55);
    canvas.strokePath();
  }
}
