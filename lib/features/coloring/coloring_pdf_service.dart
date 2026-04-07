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
    // 追加18種類
    // カーネーション=\u30ab\u30fc\u30cd\u30fc\u30b7\u30e7\u30f3
    // こいのぼり=\u3053\u3044\u306e\u307c\u308a
    // ひな人形=\u3072\u306a\u4eba\u5f62
    // スイカ=\u30b9\u30a4\u30ab
    // 風鈴=\u98a8\u9234 花火=\u82b1\u706b かき氷=\u304b\u304d\u6c37
    // お月見=\u304a\u6708\u898b 菊の花=\u83ca\u306e\u82b1 トンボ=\u30c8\u30f3\u30dc
    // 椿=\u6912 門松=\u9580\u677e 節分の鬼=\u7bc0\u5206\u306e\u9b3c
    // みかん=\u307f\u304b\u3093 だるま=\u3060\u308b\u307e
    // 折り鶴=\u6298\u308a\u9db4 桃の花=\u6843\u306e\u82b1 ひし餅=\u3072\u3057\u9905
    } else if (name == '\u30ab\u30fc\u30cd\u30fc\u30b7\u30e7\u30f3') {
      _drawCarnation(canvas, size);
    } else if (name == '\u3053\u3044\u306e\u307c\u308a') {
      _drawKoinobori(canvas, size);
    } else if (name == '\u3072\u306a\u4eba\u5f62') {
      _drawHinaDoll(canvas, size);
    } else if (name == '\u30b9\u30a4\u30ab') {
      _drawWatermelon(canvas, size);
    } else if (name == '\u98a8\u9234') {
      _drawWindChime(canvas, size);
    } else if (name == '\u82b1\u706b') {
      _drawFireworks(canvas, size);
    } else if (name == '\u304b\u304d\u6c37') {
      _drawShavedIce(canvas, size);
    } else if (name == '\u304a\u6708\u898b') {
      _drawMoonViewing(canvas, size);
    } else if (name == '\u83ca\u306e\u82b1') {
      _drawChrysanthemum(canvas, size);
    } else if (name == '\u30c8\u30f3\u30dc') {
      _drawDragonfly(canvas, size);
    } else if (name == '\u6912') {
      _drawCamellia(canvas, size);
    } else if (name == '\u9580\u677e') {
      _drawKadomatsu(canvas, size);
    } else if (name == '\u7bc0\u5206\u306e\u9b3c') {
      _drawOni(canvas, size);
    } else if (name == '\u307f\u304b\u3093') {
      _drawMikan(canvas, size);
    } else if (name == '\u3060\u308b\u307e') {
      _drawDaruma(canvas, size);
    } else if (name == '\u6298\u308a\u9db4') {
      _drawOrigamiCrane(canvas, size);
    } else if (name == '\u6843\u306e\u82b1') {
      _drawPeachBlossom(canvas, size);
    } else if (name == '\u3072\u3057\u9905') {
      _drawHishimochi(canvas, size);
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

  // ── カーネーション ────────────────────────────────────────────────────────
  static void _drawCarnation(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2 + 40;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // 花びら（多層の波型）
    for (int layer = 0; layer < 3; layer++) {
      final r = 80.0 + layer * 25;
      for (int i = 0; i < 8; i++) {
        final a1 = i * math.pi / 4;
        final a2 = (i + 0.5) * math.pi / 4;
        final a3 = (i + 1) * math.pi / 4;
        canvas.moveTo(cx + r * 0.6 * math.cos(a1), cy + r * 0.6 * math.sin(a1));
        canvas.curveTo(
          cx + r * math.cos(a1), cy + r * math.sin(a1),
          cx + r * math.cos(a2), cy + r * math.sin(a2),
          cx + r * 0.6 * math.cos(a3), cy + r * 0.6 * math.sin(a3),
        );
      }
      canvas.strokePath();
    }
    // 中心
    canvas.setLineWidth(1.5);
    canvas.drawEllipse(cx, cy, 25, 25);
    canvas.strokePath();
    // 茎
    canvas.setLineWidth(3.0);
    canvas.drawLine(cx, cy - 80, cx, cy - 280);
    canvas.strokePath();
    // 葉
    canvas.moveTo(cx, cy - 180);
    canvas.curveTo(cx + 60, cy - 150, cx + 80, cy - 100, cx + 50, cy - 80);
    canvas.curveTo(cx + 30, cy - 130, cx + 10, cy - 170, cx, cy - 190);
    canvas.strokePath();
  }

  // ── こいのぼり ────────────────────────────────────────────────────────────
  static void _drawKoinobori(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // ポール
    canvas.drawLine(cx - 150, 60, cx - 150, 620);
    canvas.strokePath();
    // 大きいこいのぼり（黒）
    canvas.moveTo(cx - 150, 530);
    canvas.curveTo(cx - 50, 560, cx + 100, 540, cx + 160, 510);
    canvas.curveTo(cx + 100, 490, cx - 50, 470, cx - 150, 500);
    canvas.closePath();
    canvas.strokePath();
    // うろこ模様
    canvas.setLineWidth(1.5);
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 4; col++) {
        final sx = cx - 110 + col * 55.0 + (row % 2) * 27;
        final sy = 500.0 + row * 18;
        canvas.moveTo(sx - 20, sy);
        canvas.curveTo(sx, sy + 15, sx + 20, sy + 15, sx + 25, sy);
        canvas.strokePath();
      }
    }
    // 小さいこいのぼり（赤）
    canvas.setLineWidth(3.0);
    canvas.moveTo(cx - 150, 440);
    canvas.curveTo(cx - 80, 465, cx + 50, 450, cx + 100, 425);
    canvas.curveTo(cx + 50, 405, cx - 80, 390, cx - 150, 415);
    canvas.closePath();
    canvas.strokePath();
    // うろこ
    canvas.setLineWidth(1.5);
    for (int col = 0; col < 3; col++) {
      final sx = cx - 110 + col * 55.0;
      canvas.moveTo(sx - 18, 420);
      canvas.curveTo(sx, 435, sx + 18, 435, sx + 22, 420);
      canvas.strokePath();
    }
    // 矢車
    canvas.setLineWidth(2.0);
    canvas.drawEllipse(cx - 150, 600, 20, 20);
    canvas.strokePath();
    for (int i = 0; i < 6; i++) {
      final a = i * math.pi / 3;
      canvas.moveTo(cx - 150, 600);
      canvas.lineTo(cx - 150 + 35 * math.cos(a), 600 + 35 * math.sin(a));
    }
    canvas.strokePath();
  }

  // ── ひな人形 ──────────────────────────────────────────────────────────────
  static void _drawHinaDoll(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // 男雛（左）
    final mx = cx - 90.0;
    canvas.drawEllipse(mx, 490, 35, 35); // 頭
    canvas.strokePath();
    canvas.moveTo(mx - 55, 460); // 体
    canvas.curveTo(mx - 60, 350, mx + 60, 350, mx + 55, 460);
    canvas.closePath();
    canvas.strokePath();
    // 女雛（右）
    final wx = cx + 90.0;
    canvas.drawEllipse(wx, 490, 35, 35);
    canvas.strokePath();
    canvas.moveTo(wx - 65, 455);
    canvas.curveTo(wx - 75, 340, wx + 75, 340, wx + 65, 455);
    canvas.closePath();
    canvas.strokePath();
    // 扇
    canvas.setLineWidth(1.5);
    canvas.moveTo(wx, 460);
    for (int i = 0; i < 5; i++) {
      final a = math.pi * 0.7 + i * math.pi * 0.1;
      canvas.lineTo(wx + 40 * math.cos(a), 460 + 40 * math.sin(a));
      canvas.moveTo(wx, 460);
    }
    canvas.strokePath();
    // 台（緋毛氈）
    canvas.setLineWidth(3.0);
    canvas.drawRect(cx - 200, 310, 400, 20);
    canvas.strokePath();
    // 飾り台
    canvas.moveTo(cx - 200, 310);
    canvas.lineTo(cx - 220, 200);
    canvas.moveTo(cx + 200, 310);
    canvas.lineTo(cx + 220, 200);
    canvas.moveTo(cx - 220, 200);
    canvas.lineTo(cx + 220, 200);
    canvas.strokePath();
    // ぼんぼり（左右）
    canvas.drawEllipse(cx - 190, 260, 20, 25);
    canvas.strokePath();
    canvas.drawLine(cx - 190, 235, cx - 190, 200);
    canvas.strokePath();
    canvas.drawEllipse(cx + 190, 260, 20, 25);
    canvas.strokePath();
    canvas.drawLine(cx + 190, 235, cx + 190, 200);
    canvas.strokePath();
  }

  // ── スイカ ────────────────────────────────────────────────────────────────
  static void _drawWatermelon(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // 断面（半円）
    canvas.moveTo(cx - 200, cy);
    canvas.curveTo(cx - 200, cy + 200, cx + 200, cy + 200, cx + 200, cy);
    canvas.closePath();
    canvas.strokePath();
    // 皮の境界線
    canvas.moveTo(cx - 185, cy);
    canvas.curveTo(cx - 185, cy + 170, cx + 185, cy + 170, cx + 185, cy);
    canvas.strokePath();
    // 縞模様（3本）
    canvas.setLineWidth(2.0);
    for (int i = -1; i <= 1; i++) {
      final x = cx + i * 65.0;
      canvas.moveTo(x, cy);
      canvas.curveTo(x - 10, cy + 80, x - 5, cy + 150, x, cy + 175);
      canvas.strokePath();
    }
    // 種（点）
    canvas.setFillColor(PdfColors.black);
    final seeds = [
      [cx - 70, cy + 80], [cx, cy + 120], [cx + 70, cy + 80],
      [cx - 40, cy + 140], [cx + 40, cy + 140],
    ];
    for (final s in seeds) {
      canvas.drawEllipse(s[0], s[1], 8, 12);
      canvas.fillPath();
    }
    // 丸いスイカ（全体）上に
    canvas.setFillColor(PdfColors.white);
    canvas.setLineWidth(3.0);
    canvas.drawEllipse(cx, cy + 100, 90, 90);
    canvas.fillPath();
    canvas.drawEllipse(cx, cy + 100, 90, 90);
    canvas.strokePath();
    // 縞
    canvas.setLineWidth(2.0);
    for (int i = 0; i < 4; i++) {
      final a = i * math.pi / 2;
      canvas.moveTo(cx, cy + 100);
      canvas.curveTo(
        cx + 40 * math.cos(a), cy + 100 + 40 * math.sin(a),
        cx + 75 * math.cos(a + 0.3), cy + 100 + 75 * math.sin(a + 0.3),
        cx + 85 * math.cos(a + 0.15), cy + 100 + 85 * math.sin(a + 0.15),
      );
      canvas.strokePath();
    }
    // へた
    canvas.setLineWidth(3.0);
    canvas.moveTo(cx, cy + 190);
    canvas.curveTo(cx - 10, cy + 210, cx + 10, cy + 220, cx + 5, cy + 210);
    canvas.strokePath();
  }

  // ── 風鈴 ──────────────────────────────────────────────────────────────────
  static void _drawWindChime(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // ひもと金具
    canvas.drawLine(cx, 620, cx, 560);
    canvas.strokePath();
    canvas.drawEllipse(cx, 555, 12, 8);
    canvas.strokePath();
    // ガラスの鐘
    canvas.moveTo(cx - 80, 550);
    canvas.curveTo(cx - 90, 500, cx - 90, 430, cx - 70, 400);
    canvas.curveTo(cx - 40, 380, cx + 40, 380, cx + 70, 400);
    canvas.curveTo(cx + 90, 430, cx + 90, 500, cx + 80, 550);
    canvas.closePath();
    canvas.strokePath();
    // 鐘の口（波型）
    canvas.setLineWidth(2.0);
    for (int i = 0; i < 4; i++) {
      final x1 = cx - 80 + i * 40.0;
      final x2 = cx - 60 + i * 40.0;
      canvas.moveTo(x1, 550);
      canvas.curveTo(x1 + 10, 565, x2 - 10, 565, x2, 550);
    }
    canvas.strokePath();
    // 模様（朝顔や花）
    canvas.setLineWidth(1.5);
    canvas.drawEllipse(cx, 480, 30, 30);
    canvas.strokePath();
    for (int i = 0; i < 6; i++) {
      final a = i * math.pi / 3;
      canvas.drawEllipse(cx + 45 * math.cos(a), 480 + 45 * math.sin(a), 15, 15);
      canvas.strokePath();
    }
    // 短冊（舌）
    canvas.setLineWidth(3.0);
    canvas.drawLine(cx, 400, cx, 300);
    canvas.drawRect(cx - 25, 250, 50, 55);
    canvas.strokePath();
    // 短冊の文字線
    canvas.setLineWidth(1.5);
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(cx - 15, 295 - i * 15.0, cx + 15, 295 - i * 15.0);
    }
    canvas.strokePath();
  }

  // ── 花火 ──────────────────────────────────────────────────────────────────
  static void _drawFireworks(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(2.5);
    // メイン花火（上）
    final fy1 = size.y * 0.65;
    for (int i = 0; i < 16; i++) {
      final a = i * math.pi / 8;
      canvas.moveTo(cx, fy1);
      canvas.curveTo(
        cx + 80 * math.cos(a), fy1 + 80 * math.sin(a),
        cx + 140 * math.cos(a), fy1 + 140 * math.sin(a),
        cx + 160 * math.cos(a), fy1 + 160 * math.sin(a),
      );
      // 先端の玉
      canvas.drawEllipse(
        cx + 165 * math.cos(a), fy1 + 165 * math.sin(a), 7, 7);
    }
    canvas.strokePath();
    // 小花火（左）
    final fx2 = cx - 140.0;
    final fy2 = size.y * 0.4;
    canvas.setLineWidth(1.5);
    for (int i = 0; i < 12; i++) {
      final a = i * math.pi / 6;
      canvas.moveTo(fx2, fy2);
      canvas.lineTo(fx2 + 80 * math.cos(a), fy2 + 80 * math.sin(a));
    }
    canvas.strokePath();
    // 小花火（右）
    final fx3 = cx + 140.0;
    final fy3 = size.y * 0.45;
    for (int i = 0; i < 10; i++) {
      final a = i * math.pi / 5;
      canvas.moveTo(fx3, fy3);
      canvas.lineTo(fx3 + 70 * math.cos(a), fy3 + 70 * math.sin(a));
    }
    canvas.strokePath();
    // 打ち上げ線
    canvas.setLineWidth(2.0);
    canvas.moveTo(cx, 60);
    canvas.curveTo(cx - 10, 100, cx + 5, 160, cx, fy1);
    canvas.strokePath();
  }

  // ── かき氷 ────────────────────────────────────────────────────────────────
  static void _drawShavedIce(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // 器（ガラス）
    canvas.moveTo(cx - 120, 200);
    canvas.lineTo(cx - 80, 100);
    canvas.lineTo(cx + 80, 100);
    canvas.lineTo(cx + 120, 200);
    canvas.closePath();
    canvas.strokePath();
    // 器の底（楕円）
    canvas.drawEllipse(cx, 200, 120, 20);
    canvas.strokePath();
    // 氷の山（ドーム）
    canvas.moveTo(cx - 100, 200);
    canvas.curveTo(cx - 120, 350, cx - 60, 450, cx, 470);
    canvas.curveTo(cx + 60, 450, cx + 120, 350, cx + 100, 200);
    canvas.strokePath();
    // 横縞（かき氷の層）
    canvas.setLineWidth(1.5);
    for (int i = 1; i <= 4; i++) {
      final y = 200.0 + i * 55;
      final w = 90.0 - i * 10;
      canvas.moveTo(cx - w, y);
      canvas.curveTo(cx - w * 0.5, y + 10, cx + w * 0.5, y + 10, cx + w, y);
      canvas.strokePath();
    }
    // シロップのたれ
    canvas.setLineWidth(2.5);
    canvas.moveTo(cx - 30, 350);
    canvas.curveTo(cx - 35, 400, cx - 20, 440, cx - 15, 465);
    canvas.moveTo(cx + 20, 380);
    canvas.curveTo(cx + 25, 420, cx + 15, 450, cx + 10, 465);
    canvas.strokePath();
    // スプーン
    canvas.setLineWidth(2.0);
    canvas.moveTo(cx + 80, 120);
    canvas.lineTo(cx + 70, 300);
    canvas.strokePath();
    canvas.drawEllipse(cx + 80, 120, 18, 25);
    canvas.strokePath();
  }

  // ── お月見 ────────────────────────────────────────────────────────────────
  static void _drawMoonViewing(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // 月（大きな円）
    canvas.drawEllipse(cx, 460, 130, 130);
    canvas.strokePath();
    // うさぎのシルエット（月の中）
    canvas.setLineWidth(2.0);
    canvas.drawEllipse(cx, 460, 50, 45); // 体
    canvas.strokePath();
    canvas.drawEllipse(cx, 500, 32, 28); // 頭
    canvas.strokePath();
    canvas.drawEllipse(cx - 15, 530, 10, 28); // 左耳
    canvas.strokePath();
    canvas.drawEllipse(cx + 15, 530, 10, 28); // 右耳
    canvas.strokePath();
    // ススキ（左）
    canvas.setLineWidth(3.0);
    canvas.moveTo(cx - 160, 100);
    canvas.curveTo(cx - 140, 250, cx - 170, 350, cx - 180, 400);
    canvas.strokePath();
    // ススキの穂
    canvas.setLineWidth(1.5);
    for (int i = 0; i < 7; i++) {
      final a = math.pi * 0.7 + i * math.pi * 0.08;
      canvas.drawLine(
        cx - 160, 100,
        cx - 160 + 40 * math.cos(a), 100 + 40 * math.sin(a),
      );
    }
    canvas.strokePath();
    // ススキ（右）
    canvas.setLineWidth(3.0);
    canvas.moveTo(cx + 160, 120);
    canvas.curveTo(cx + 145, 260, cx + 175, 360, cx + 185, 410);
    canvas.strokePath();
    canvas.setLineWidth(1.5);
    for (int i = 0; i < 7; i++) {
      final a = math.pi * 0.22 + i * math.pi * 0.08;
      canvas.drawLine(
        cx + 160, 120,
        cx + 160 + 40 * math.cos(a), 120 + 40 * math.sin(a),
      );
    }
    canvas.strokePath();
    // お月見台（三方）
    canvas.setLineWidth(3.0);
    canvas.drawRect(cx - 80, 290, 160, 15);
    canvas.strokePath();
    canvas.drawRect(cx - 50, 260, 100, 30);
    canvas.strokePath();
    canvas.drawRect(cx - 60, 245, 120, 18);
    canvas.strokePath();
    // お団子（3段）
    for (int row = 0; row < 3; row++) {
      final count = row + 1;
      for (int col = 0; col < count; col++) {
        final x = cx + (col - (count - 1) / 2) * 48.0;
        final y = 240.0 - row * 45;
        canvas.drawEllipse(x, y, 20, 20);
        canvas.strokePath();
      }
    }
  }

  // ── 菊の花 ────────────────────────────────────────────────────────────────
  static void _drawChrysanthemum(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2 + 30;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(2.0);
    // 外側の花びら（細長い）
    for (int i = 0; i < 20; i++) {
      final a = i * 2 * math.pi / 20;
      final px = cx + 160 * math.cos(a);
      final py = cy + 160 * math.sin(a);
      canvas.moveTo(cx + 25 * math.cos(a - 0.15), cy + 25 * math.sin(a - 0.15));
      canvas.curveTo(
        cx + 100 * math.cos(a - 0.12), cy + 100 * math.sin(a - 0.12),
        px - 10 * math.cos(a - 0.3), py - 10 * math.sin(a - 0.3),
        px, py,
      );
      canvas.curveTo(
        px - 10 * math.cos(a + 0.3), py - 10 * math.sin(a + 0.3),
        cx + 100 * math.cos(a + 0.12), cy + 100 * math.sin(a + 0.12),
        cx + 25 * math.cos(a + 0.15), cy + 25 * math.sin(a + 0.15),
      );
    }
    canvas.strokePath();
    // 内側の花びら
    canvas.setLineWidth(1.5);
    for (int i = 0; i < 14; i++) {
      final a = i * 2 * math.pi / 14 + math.pi / 14;
      final px = cx + 90 * math.cos(a);
      final py = cy + 90 * math.sin(a);
      canvas.moveTo(cx + 18 * math.cos(a), cy + 18 * math.sin(a));
      canvas.lineTo(px, py);
    }
    canvas.strokePath();
    // 中心
    canvas.setLineWidth(2.5);
    canvas.drawEllipse(cx, cy, 22, 22);
    canvas.strokePath();
    // 茎と葉
    canvas.setLineWidth(3.0);
    canvas.moveTo(cx, cy - 160);
    canvas.lineTo(cx, cy - 330);
    canvas.strokePath();
    canvas.moveTo(cx, cy - 240);
    canvas.curveTo(cx + 60, cy - 210, cx + 90, cy - 170, cx + 70, cy - 150);
    canvas.curveTo(cx + 40, cy - 200, cx + 15, cy - 230, cx, cy - 250);
    canvas.strokePath();
  }

  // ── トンボ ────────────────────────────────────────────────────────────────
  static void _drawDragonfly(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // 胴体
    canvas.moveTo(cx, cy + 160);
    canvas.curveTo(cx - 15, cy + 80, cx - 10, cy, cx, cy - 20);
    canvas.curveTo(cx + 10, cy, cx + 15, cy + 80, cx, cy + 160);
    canvas.strokePath();
    // しっぽ（細長い）
    canvas.setLineWidth(2.5);
    canvas.moveTo(cx, cy - 20);
    canvas.lineTo(cx, cy - 220);
    canvas.strokePath();
    // しっぽの節
    canvas.setLineWidth(1.5);
    for (int i = 1; i <= 6; i++) {
      canvas.drawEllipse(cx, cy - 20 - i * 30.0, 10, 6);
      canvas.strokePath();
    }
    // 頭（大きな目）
    canvas.setLineWidth(3.0);
    canvas.drawEllipse(cx, cy + 185, 28, 24);
    canvas.strokePath();
    canvas.setFillColor(PdfColors.black);
    canvas.drawEllipse(cx - 12, cy + 185, 10, 10);
    canvas.fillPath();
    canvas.drawEllipse(cx + 12, cy + 185, 10, 10);
    canvas.fillPath();
    // 上の羽（2枚）
    canvas.setLineWidth(2.0);
    canvas.moveTo(cx, cy + 120);
    canvas.curveTo(cx - 60, cy + 170, cx - 200, cy + 120, cx - 180, cy + 60);
    canvas.curveTo(cx - 150, cy, cx - 60, cy + 60, cx, cy + 80);
    canvas.strokePath();
    canvas.moveTo(cx, cy + 120);
    canvas.curveTo(cx + 60, cy + 170, cx + 200, cy + 120, cx + 180, cy + 60);
    canvas.curveTo(cx + 150, cy, cx + 60, cy + 60, cx, cy + 80);
    canvas.strokePath();
    // 下の羽（2枚）
    canvas.moveTo(cx, cy + 100);
    canvas.curveTo(cx - 50, cy + 140, cx - 170, cy + 110, cx - 155, cy + 60);
    canvas.curveTo(cx - 130, cy + 20, cx - 50, cy + 60, cx, cy + 70);
    canvas.strokePath();
    canvas.moveTo(cx, cy + 100);
    canvas.curveTo(cx + 50, cy + 140, cx + 170, cy + 110, cx + 155, cy + 60);
    canvas.curveTo(cx + 130, cy + 20, cx + 50, cy + 60, cx, cy + 70);
    canvas.strokePath();
    // 羽の脈
    canvas.setLineWidth(1.0);
    canvas.drawLine(cx, cy + 90, cx - 170, cy + 85);
    canvas.drawLine(cx, cy + 90, cx + 170, cy + 85);
    canvas.strokePath();
  }

  // ── 椿 ───────────────────────────────────────────────────────────────────
  static void _drawCamellia(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2 + 40;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // 外側の花びら（5枚・大きく）
    for (int i = 0; i < 5; i++) {
      final a = i * 2 * math.pi / 5 - math.pi / 2;
      canvas.moveTo(cx, cy);
      canvas.curveTo(
        cx + 100 * math.cos(a - 0.4), cy + 100 * math.sin(a - 0.4),
        cx + 160 * math.cos(a), cy + 160 * math.sin(a),
        cx + 130 * math.cos(a), cy + 130 * math.sin(a),
      );
      canvas.curveTo(
        cx + 160 * math.cos(a), cy + 160 * math.sin(a),
        cx + 100 * math.cos(a + 0.4), cy + 100 * math.sin(a + 0.4),
        cx, cy,
      );
      canvas.strokePath();
    }
    // 中心のおしべ（放射状）
    canvas.setLineWidth(1.5);
    for (int i = 0; i < 20; i++) {
      final a = i * math.pi / 10;
      canvas.moveTo(cx + 15 * math.cos(a), cy + 15 * math.sin(a));
      canvas.lineTo(cx + 55 * math.cos(a), cy + 55 * math.sin(a));
    }
    canvas.strokePath();
    canvas.drawEllipse(cx, cy, 55, 55);
    canvas.strokePath();
    canvas.drawEllipse(cx, cy, 15, 15);
    canvas.strokePath();
    // 葉（2枚・光沢感のある丸い葉）
    canvas.setLineWidth(3.0);
    canvas.moveTo(cx + 130, cy - 30);
    canvas.curveTo(cx + 200, cy - 50, cx + 230, cy - 150, cx + 180, cy - 160);
    canvas.curveTo(cx + 140, cy - 170, cx + 100, cy - 100, cx + 130, cy - 30);
    canvas.strokePath();
    canvas.setLineWidth(1.5);
    canvas.moveTo(cx + 130, cy - 30);
    canvas.lineTo(cx + 190, cy - 140);
    canvas.strokePath();
    canvas.setLineWidth(3.0);
    canvas.moveTo(cx - 120, cy - 50);
    canvas.curveTo(cx - 190, cy - 60, cx - 220, cy - 160, cx - 175, cy - 170);
    canvas.curveTo(cx - 135, cy - 180, cx - 100, cy - 110, cx - 120, cy - 50);
    canvas.strokePath();
  }

  // ── 門松 ──────────────────────────────────────────────────────────────────
  static void _drawKadomatsu(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // 竹（3本・高さ違い）
    final heights = [580.0, 480.0, 540.0];
    final xPos = [cx - 50.0, cx + 50.0, cx.toDouble()];
    for (int i = 0; i < 3; i++) {
      // 竹の胴
      canvas.drawRect(xPos[i] - 25, 160, 50, heights[i] - 160);
      canvas.strokePath();
      // 節
      canvas.setLineWidth(2.0);
      for (double y = heights[i] - 80; y > 200; y -= 100) {
        canvas.drawLine(xPos[i] - 25, y, xPos[i] + 25, y);
        canvas.strokePath();
      }
      canvas.setLineWidth(3.0);
      // 竹の斜め切り口
      canvas.moveTo(xPos[i] - 25, heights[i]);
      canvas.lineTo(xPos[i] + 25, heights[i] - 40);
      canvas.strokePath();
    }
    // 台（こもと縄）
    canvas.drawRect(cx - 110, 140, 220, 30);
    canvas.strokePath();
    canvas.drawRect(cx - 90, 100, 180, 45);
    canvas.strokePath();
    // 松の枝（左右）
    canvas.setLineWidth(2.0);
    canvas.moveTo(cx - 75, 400);
    canvas.curveTo(cx - 150, 380, cx - 200, 330, cx - 180, 300);
    canvas.strokePath();
    canvas.moveTo(cx + 75, 400);
    canvas.curveTo(cx + 150, 380, cx + 200, 330, cx + 180, 300);
    canvas.strokePath();
    // 松葉（小さな線）
    canvas.setLineWidth(1.0);
    for (int i = 0; i < 8; i++) {
      final a = math.pi * 0.8 + i * math.pi * 0.05;
      canvas.drawLine(cx - 180, 300, cx - 180 + 30 * math.cos(a), 300 + 30 * math.sin(a));
      canvas.drawLine(cx + 180, 300, cx + 180 - 30 * math.cos(a), 300 + 30 * math.sin(a));
    }
    canvas.strokePath();
    // 梅の花（飾り）
    canvas.setLineWidth(2.0);
    for (int i = 0; i < 5; i++) {
      final a = i * 2 * math.pi / 5;
      canvas.drawEllipse(cx + 35 * math.cos(a), 200 + 35 * math.sin(a), 16, 16);
      canvas.strokePath();
    }
    canvas.drawEllipse(cx, 200.0, 10, 10);
    canvas.strokePath();
  }

  // ── 節分の鬼 ──────────────────────────────────────────────────────────────
  static void _drawOni(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // 体
    canvas.drawEllipse(cx, 250, 130, 160);
    canvas.strokePath();
    // 頭
    canvas.setFillColor(PdfColors.white);
    canvas.drawEllipse(cx, 460, 100, 90);
    canvas.fillPath();
    canvas.drawEllipse(cx, 460, 100, 90);
    canvas.strokePath();
    // 角（2本）
    canvas.moveTo(cx - 60, 520);
    canvas.curveTo(cx - 80, 560, cx - 65, 600, cx - 50, 590);
    canvas.curveTo(cx - 40, 580, cx - 35, 550, cx - 50, 510);
    canvas.strokePath();
    canvas.moveTo(cx + 60, 520);
    canvas.curveTo(cx + 80, 560, cx + 65, 600, cx + 50, 590);
    canvas.curveTo(cx + 40, 580, cx + 35, 550, cx + 50, 510);
    canvas.strokePath();
    // 目（つり目）
    canvas.setLineWidth(2.0);
    canvas.moveTo(cx - 55, 480);
    canvas.lineTo(cx - 25, 472);
    canvas.moveTo(cx + 55, 480);
    canvas.lineTo(cx + 25, 472);
    canvas.strokePath();
    canvas.setFillColor(PdfColors.black);
    canvas.drawEllipse(cx - 38, 475, 10, 10);
    canvas.fillPath();
    canvas.drawEllipse(cx + 38, 475, 10, 10);
    canvas.fillPath();
    // 鼻
    canvas.setLineWidth(2.5);
    canvas.drawEllipse(cx, 458, 18, 12);
    canvas.strokePath();
    // 口（大きく）
    canvas.moveTo(cx - 50, 438);
    canvas.curveTo(cx - 30, 420, cx + 30, 420, cx + 50, 438);
    canvas.strokePath();
    // 牙
    canvas.moveTo(cx - 25, 438);
    canvas.lineTo(cx - 20, 418);
    canvas.lineTo(cx - 10, 438);
    canvas.moveTo(cx + 25, 438);
    canvas.lineTo(cx + 20, 418);
    canvas.lineTo(cx + 10, 438);
    canvas.strokePath();
    // 金棒
    canvas.setLineWidth(4.0);
    canvas.moveTo(cx + 100, 160);
    canvas.lineTo(cx + 150, 400);
    canvas.strokePath();
    // 金棒のとげ
    canvas.setLineWidth(2.5);
    for (int i = 0; i < 4; i++) {
      final y = 200.0 + i * 50;
      canvas.drawLine(cx + 100 + i * 10, y, cx + 90 + i * 10, y - 25);
      canvas.strokePath();
    }
  }

  // ── みかん ────────────────────────────────────────────────────────────────
  static void _drawMikan(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // 実（大きな円）
    canvas.drawEllipse(cx, cy, 170, 150);
    canvas.strokePath();
    // へた
    canvas.drawRect(cx - 20, cy + 155, 40, 18);
    canvas.strokePath();
    // 葉
    canvas.moveTo(cx - 10, cy + 170);
    canvas.curveTo(cx - 40, cy + 200, cx - 90, cy + 180, cx - 80, cy + 155);
    canvas.curveTo(cx - 70, cy + 130, cx - 20, cy + 150, cx - 10, cy + 170);
    canvas.strokePath();
    canvas.setLineWidth(1.5);
    canvas.moveTo(cx - 10, cy + 170);
    canvas.lineTo(cx - 75, cy + 162);
    canvas.strokePath();
    // 実の縦線（8等分）
    canvas.setLineWidth(1.5);
    for (int i = 1; i < 8; i++) {
      final a = -math.pi / 2 + i * 2 * math.pi / 8;
      canvas.moveTo(cx, cy + 155);
      canvas.curveTo(
        cx + 80 * math.cos(a), cy + 80 * math.sin(a),
        cx + 150 * math.cos(a), cy + 130 * math.sin(a),
        cx + 165 * math.cos(a), cy + 145 * math.sin(a),
      );
      canvas.strokePath();
    }
    // へたの星形
    canvas.setLineWidth(2.0);
    for (int i = 0; i < 5; i++) {
      final a = i * 2 * math.pi / 5 - math.pi / 2;
      canvas.drawLine(cx, cy + 163, cx + 22 * math.cos(a), cy + 163 + 22 * math.sin(a));
    }
    canvas.strokePath();
  }

  // ── だるま ────────────────────────────────────────────────────────────────
  static void _drawDaruma(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // 体（大きな丸）
    canvas.drawEllipse(cx, cy - 30, 170, 190);
    canvas.strokePath();
    // 顔（白い部分）
    canvas.setFillColor(PdfColors.white);
    canvas.drawEllipse(cx, cy + 40, 110, 100);
    canvas.fillPath();
    canvas.drawEllipse(cx, cy + 40, 110, 100);
    canvas.strokePath();
    // 眉（太い）
    canvas.setLineWidth(4.0);
    canvas.moveTo(cx - 60, cy + 80);
    canvas.curveTo(cx - 40, cy + 100, cx - 10, cy + 95, cx, cy + 90);
    canvas.moveTo(cx + 60, cy + 80);
    canvas.curveTo(cx + 40, cy + 100, cx + 10, cy + 95, cx, cy + 90);
    canvas.strokePath();
    // 目（白目のみ・片目空白）
    canvas.setLineWidth(2.5);
    canvas.drawEllipse(cx - 35, cy + 50, 22, 20);
    canvas.strokePath();
    canvas.drawEllipse(cx + 35, cy + 50, 22, 20);
    canvas.strokePath();
    // 鼻
    canvas.setLineWidth(2.0);
    canvas.drawEllipse(cx, cy + 30, 10, 8);
    canvas.strokePath();
    // ひげ
    canvas.setLineWidth(2.5);
    canvas.moveTo(cx - 20, cy + 20);
    canvas.lineTo(cx - 90, cy + 10);
    canvas.moveTo(cx - 20, cy + 12);
    canvas.lineTo(cx - 85, cy + 0);
    canvas.moveTo(cx + 20, cy + 20);
    canvas.lineTo(cx + 90, cy + 10);
    canvas.moveTo(cx + 20, cy + 12);
    canvas.lineTo(cx + 85, cy + 0);
    canvas.strokePath();
    // 底の帯
    canvas.setLineWidth(3.0);
    canvas.moveTo(cx - 165, cy - 80);
    canvas.curveTo(cx - 160, cy - 60, cx + 160, cy - 60, cx + 165, cy - 80);
    canvas.strokePath();
    // 家紋風の模様（円と線）
    canvas.setLineWidth(1.5);
    canvas.drawEllipse(cx, cy - 150, 45, 45);
    canvas.strokePath();
    for (int i = 0; i < 4; i++) {
      final a = i * math.pi / 2;
      canvas.drawLine(cx, cy - 150, cx + 42 * math.cos(a), cy - 150 + 42 * math.sin(a));
    }
    canvas.strokePath();
  }

  // ── 折り鶴 ────────────────────────────────────────────────────────────────
  static void _drawOrigamiCrane(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // 胴体（菱形）
    canvas.moveTo(cx, cy + 120);       // 下
    canvas.lineTo(cx - 140, cy);       // 左
    canvas.lineTo(cx, cy - 80);        // 上
    canvas.lineTo(cx + 140, cy);       // 右
    canvas.closePath();
    canvas.strokePath();
    // 右羽
    canvas.moveTo(cx, cy);
    canvas.curveTo(cx + 80, cy + 50, cx + 220, cy - 20, cx + 200, cy - 100);
    canvas.curveTo(cx + 170, cy - 160, cx + 80, cy - 80, cx, cy - 40);
    canvas.strokePath();
    // 左羽
    canvas.moveTo(cx, cy);
    canvas.curveTo(cx - 80, cy + 50, cx - 220, cy - 20, cx - 200, cy - 100);
    canvas.curveTo(cx - 170, cy - 160, cx - 80, cy - 80, cx, cy - 40);
    canvas.strokePath();
    // 首（細長く伸びる）
    canvas.moveTo(cx - 30, cy - 80);
    canvas.curveTo(cx - 50, cy - 120, cx - 60, cy - 180, cx - 40, cy - 220);
    canvas.strokePath();
    // 頭
    canvas.drawEllipse(cx - 35, cy - 235, 22, 18);
    canvas.strokePath();
    // くちばし
    canvas.moveTo(cx - 20, cy - 240);
    canvas.lineTo(cx + 15, cy - 255);
    canvas.strokePath();
    // 尾（後ろに突き出る）
    canvas.moveTo(cx + 30, cy - 60);
    canvas.curveTo(cx + 60, cy - 90, cx + 80, cy - 140, cx + 65, cy - 165);
    canvas.strokePath();
    // 折り目の線
    canvas.setLineWidth(1.5);
    canvas.moveTo(cx, cy + 120);
    canvas.lineTo(cx, cy - 80);
    canvas.moveTo(cx - 140, cy);
    canvas.lineTo(cx + 140, cy);
    canvas.strokePath();
    canvas.setLineWidth(1.0);
    canvas.moveTo(cx, cy);
    canvas.lineTo(cx + 140, cy);
    canvas.strokePath();
  }

  // ── 桃の花 ────────────────────────────────────────────────────────────────
  static void _drawPeachBlossom(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2 + 50;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // 5枚のハート型花びら
    for (int i = 0; i < 5; i++) {
      final a = i * 2 * math.pi / 5 - math.pi / 2;
      final px = cx + 90 * math.cos(a);
      final py = cy + 90 * math.sin(a);
      // ハート型の花びら（先端にくぼみ）
      canvas.moveTo(cx + 20 * math.cos(a - 0.4), cy + 20 * math.sin(a - 0.4));
      canvas.curveTo(
        px + 60 * math.cos(a - math.pi / 2), py + 60 * math.sin(a - math.pi / 2),
        px + 50 * math.cos(a - math.pi / 3), py + 50 * math.sin(a - math.pi / 3),
        px, py,
      );
      canvas.curveTo(
        px + 50 * math.cos(a + math.pi / 3), py + 50 * math.sin(a + math.pi / 3),
        px + 60 * math.cos(a + math.pi / 2), py + 60 * math.sin(a + math.pi / 2),
        cx + 20 * math.cos(a + 0.4), cy + 20 * math.sin(a + 0.4),
      );
      canvas.strokePath();
    }
    // 中心
    canvas.setLineWidth(1.5);
    canvas.drawEllipse(cx, cy, 20, 20);
    canvas.strokePath();
    for (int i = 0; i < 10; i++) {
      final a = i * math.pi / 5;
      canvas.moveTo(cx + 20 * math.cos(a), cy + 20 * math.sin(a));
      canvas.lineTo(cx + 50 * math.cos(a), cy + 50 * math.sin(a));
    }
    canvas.strokePath();
    // 枝
    canvas.setLineWidth(4.0);
    canvas.moveTo(cx, cy - 90);
    canvas.curveTo(cx - 20, cy - 180, cx - 30, cy - 280, cx - 20, cy - 320);
    canvas.strokePath();
    canvas.moveTo(cx - 20, cy - 240);
    canvas.curveTo(cx + 40, cy - 220, cx + 80, cy - 180, cx + 70, cy - 150);
    canvas.strokePath();
  }

  // ── ひし餅 ────────────────────────────────────────────────────────────────
  static void _drawHishimochi(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    canvas.setStrokeColor(PdfColors.black);
    canvas.setLineWidth(3.0);
    // ひし餅（3層の菱形）
    final colors = [PdfColors.white, PdfColors.white, PdfColors.white];
    final layers = [
      [cx, 480.0, 160.0, 50.0], // 下（白/菱餅）
      [cx, 390.0, 130.0, 45.0], // 中（白）
      [cx, 310.0, 100.0, 38.0], // 上（白）
    ];
    for (int i = 0; i < 3; i++) {
      final lx = layers[i][0];
      final ly = layers[i][1];
      final lw = layers[i][2];
      final lh = layers[i][3];
      canvas.setFillColor(colors[i]);
      canvas.moveTo(lx, ly + lh);      // 下
      canvas.lineTo(lx - lw, ly);      // 左
      canvas.lineTo(lx, ly - lh);      // 上
      canvas.lineTo(lx + lw, ly);      // 右
      canvas.closePath();
      canvas.fillPath();
      canvas.moveTo(lx, ly + lh);
      canvas.lineTo(lx - lw, ly);
      canvas.lineTo(lx, ly - lh);
      canvas.lineTo(lx + lw, ly);
      canvas.closePath();
      canvas.strokePath();
    }
    // 段差のライン
    canvas.setLineWidth(2.0);
    canvas.drawLine(cx - 160, 480, cx + 160, 480);
    canvas.drawLine(cx - 130, 390, cx + 130, 390);
    canvas.strokePath();
    // 台（三方）
    canvas.setLineWidth(3.0);
    canvas.drawRect(cx - 120, 490, 240, 18);
    canvas.strokePath();
    canvas.drawRect(cx - 80, 508, 160, 35);
    canvas.strokePath();
    canvas.drawRect(cx - 100, 543, 200, 16);
    canvas.strokePath();
    // 桃の花の飾り（上部）
    canvas.setLineWidth(2.0);
    for (int i = 0; i < 5; i++) {
      final a = i * 2 * math.pi / 5 - math.pi / 2;
      canvas.drawEllipse(cx + 35 * math.cos(a), 260 + 35 * math.sin(a), 16, 16);
      canvas.strokePath();
    }
    canvas.drawEllipse(cx, 260.0, 10, 10);
    canvas.strokePath();
  }
}
