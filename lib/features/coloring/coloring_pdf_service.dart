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
    // compare by codepoints to avoid encoding issues
    if (name == '\u685c') {
      _drawSakura(canvas, size);
    } else if (name == '\u30c1\u30e5\u30fc\u30ea\u30c3\u30d7') {
      _drawTulip(canvas, size);
    } else if (name == '\u3072\u307e\u308f\u308a') {
      _drawSunflower(canvas, size);
    } else if (name == '\u671d\u984f') {
      _drawMorningGlory(canvas, size);
    } else if (name == '\u3082\u307f\u3058') {
      _drawMapleLeaf(canvas, size);
    } else if (name == '\u3069\u3093\u3050\u308a') {
      _drawAcorn(canvas, size);
    } else if (name == '\u96ea\u3060\u308b\u307e') {
      _drawSnowman(canvas, size);
    } else if (name == '\u5bcd\u58eb\u5c71') {
      _drawFuji(canvas, size);
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

  static void _c(PdfGraphics g, double x, double y, double r) =>
      g.drawEllipse(x, y, r, r);

  static void _drawLeaf(PdfGraphics canvas, double x, double y, double angle,
      double length, double width) {
    final ex = x + length * math.cos(angle);
    final ey = y + length * math.sin(angle);
    final mx = x + (length / 2) * math.cos(angle);
    final my = y + (length / 2) * math.sin(angle);
    final pa = angle + math.pi / 2;
    canvas.moveTo(x, y);
    canvas.curveTo(
        mx + width * math.cos(pa), my + width * math.sin(pa),
        ex + (width * 0.3) * math.cos(pa), ey + (width * 0.3) * math.sin(pa),
        ex, ey);
    canvas.curveTo(
        ex - (width * 0.3) * math.cos(pa), ey - (width * 0.3) * math.sin(pa),
        mx - width * math.cos(pa), my - width * math.sin(pa),
        x, y);
    canvas.strokePath();
    canvas.setLineWidth(1.5);
    canvas.moveTo(x, y);
    canvas.lineTo(ex, ey);
    canvas.strokePath();
    canvas.setLineWidth(3.0);
  }

  static void _drawSakura(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    const fy = 430.0;
    for (var i = 0; i < 5; i++) {
      final a = -math.pi / 2 + i * 2 * math.pi / 5;
      _c(canvas, cx + 80 * math.cos(a), fy + 80 * math.sin(a), 85);
      canvas.strokePath();
    }
    canvas.setFillColor(PdfColors.white);
    _c(canvas, cx, fy, 50); canvas.fillPath();
    _c(canvas, cx, fy, 50); canvas.strokePath();
    canvas.setLineWidth(1.5);
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      canvas.moveTo(cx + 20 * math.cos(a), fy + 20 * math.sin(a));
      canvas.lineTo(cx + 45 * math.cos(a), fy + 45 * math.sin(a));
    }
    canvas.strokePath();
    canvas.setLineWidth(4.0);
    canvas.moveTo(cx, fy - 160);
    canvas.curveTo(cx - 20, fy - 220, cx - 10, fy - 300, cx, 80);
    canvas.strokePath();
    canvas.setLineWidth(3.0);
    _drawLeaf(canvas, cx - 5, 230, -math.pi * 0.4, 75, 30);
    _drawLeaf(canvas, cx + 10, 160, math.pi * 1.6, 65, 25);
  }

  static void _drawTulip(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    canvas.moveTo(cx, 570);
    canvas.curveTo(cx - 60, 570, cx - 120, 510, cx - 110, 400);
    canvas.curveTo(cx - 80, 380, cx - 40, 390, cx, 380);
    canvas.strokePath();
    canvas.moveTo(cx, 570);
    canvas.curveTo(cx + 60, 570, cx + 120, 510, cx + 110, 400);
    canvas.curveTo(cx + 80, 380, cx + 40, 390, cx, 380);
    canvas.strokePath();
    canvas.moveTo(cx - 50, 545);
    canvas.curveTo(cx - 30, 595, cx + 30, 595, cx + 50, 545);
    canvas.strokePath();
    canvas.setLineWidth(4.0);
    canvas.moveTo(cx, 380); canvas.lineTo(cx, 110); canvas.strokePath();
    canvas.setLineWidth(3.0);
    canvas.moveTo(cx, 280);
    canvas.curveTo(cx - 20, 280, cx - 110, 325, cx - 85, 368);
    canvas.curveTo(cx - 70, 378, cx - 25, 365, cx, 330);
    canvas.strokePath();
    canvas.moveTo(cx, 210);
    canvas.curveTo(cx + 20, 210, cx + 110, 255, cx + 85, 298);
    canvas.curveTo(cx + 70, 308, cx + 25, 295, cx, 260);
    canvas.strokePath();
  }

  static void _drawSunflower(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    const fy = 420.0;
    const cr = 80.0;
    canvas.setLineWidth(2.0);
    for (var i = 0; i < 14; i++) {
      final a = i * 2 * math.pi / 14;
      canvas.drawEllipse(cx + (cr + 50) * math.cos(a),
          fy + (cr + 50) * math.sin(a), 16, 50);
      canvas.strokePath();
    }
    canvas.setLineWidth(3.0);
    canvas.setFillColor(PdfColors.white);
    _c(canvas, cx, fy, cr); canvas.fillPath();
    _c(canvas, cx, fy, cr); canvas.strokePath();
    canvas.setLineWidth(1.0);
    for (var i = 1; i <= 5; i++) { _c(canvas, cx, fy, i * 14.0); canvas.strokePath(); }
    for (var i = 0; i < 12; i++) {
      final a = i * math.pi / 6;
      canvas.moveTo(cx, fy);
      canvas.lineTo(cx + 72 * math.cos(a), fy + 72 * math.sin(a));
    }
    canvas.strokePath();
    canvas.setLineWidth(5.0);
    canvas.moveTo(cx, fy - cr);
    canvas.curveTo(cx - 10, fy - cr - 60, cx - 20, 200, cx - 10, 80);
    canvas.strokePath();
    canvas.setLineWidth(3.0);
    _drawLeaf(canvas, cx - 10, 260, -math.pi * 0.35, 85, 35);
    _drawLeaf(canvas, cx - 5, 180, math.pi * 1.65, 75, 30);
  }

  static void _drawMorningGlory(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    const fy = 420.0;
    const oR = 140.0;
    const iR = 42.0;
    for (var i = 0; i < 5; i++) {
      final a = i * 2 * math.pi / 5 - math.pi / 2;
      _c(canvas, cx + oR * math.cos(a), fy + oR * math.sin(a), 72);
      canvas.strokePath();
    }
    canvas.setFillColor(PdfColors.white);
    _c(canvas, cx, fy, oR - 15); canvas.fillPath();
    canvas.setLineWidth(1.5);
    for (var i = 0; i < 5; i++) {
      final a = i * 2 * math.pi / 5 - math.pi / 2;
      canvas.moveTo(cx + iR * math.cos(a), fy + iR * math.sin(a));
      canvas.lineTo(cx + oR * math.cos(a), fy + oR * math.sin(a));
    }
    canvas.strokePath();
    canvas.setLineWidth(3.0);
    _c(canvas, cx, fy, iR); canvas.strokePath();
    canvas.moveTo(cx, fy - oR + 15);
    canvas.curveTo(cx + 30, fy - oR - 40, cx + 60, 280, cx + 20, 80);
    canvas.strokePath();
    _drawLeaf(canvas, cx + 15, 280, math.pi * 1.65, 70, 30);
    _drawLeaf(canvas, cx + 30, 180, -math.pi * 0.3, 70, 30);
  }

  static void _drawMapleLeaf(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    const ly = 390.0;
    const sc = 135.0;
    final pts = [
      [0.0, 1.0], [-0.15, 0.65], [-0.5, 0.8], [-0.45, 0.45],
      [-0.85, 0.45], [-0.55, 0.15], [-0.7, -0.2], [-0.35, -0.1],
      [-0.25, -0.5], [0.0, -0.3], [0.25, -0.5], [0.35, -0.1],
      [0.7, -0.2], [0.55, 0.15], [0.85, 0.45], [0.45, 0.45],
      [0.5, 0.8], [0.15, 0.65],
    ];
    canvas.moveTo(cx + pts[0][0] * sc, ly + pts[0][1] * sc);
    for (var i = 1; i < pts.length; i++) {
      canvas.lineTo(cx + pts[i][0] * sc, ly + pts[i][1] * sc);
    }
    canvas.closePath(); canvas.strokePath();
    canvas.setLineWidth(1.5);
    canvas.moveTo(cx, ly - 0.3 * sc); canvas.lineTo(cx, ly + 0.85 * sc);
    canvas.moveTo(cx, ly + 0.3 * sc); canvas.lineTo(cx - 0.8 * sc, ly + 0.4 * sc);
    canvas.moveTo(cx, ly + 0.3 * sc); canvas.lineTo(cx + 0.8 * sc, ly + 0.4 * sc);
    canvas.moveTo(cx, ly); canvas.lineTo(cx - 0.45 * sc, ly + 0.72 * sc);
    canvas.moveTo(cx, ly); canvas.lineTo(cx + 0.45 * sc, ly + 0.72 * sc);
    canvas.strokePath();
    canvas.setLineWidth(3.0);
    canvas.moveTo(cx, ly - 0.3 * sc); canvas.lineTo(cx, 80); canvas.strokePath();
  }

  static void _drawAcorn(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    const ay = 320.0;
    canvas.drawEllipse(cx, ay, 110, 130); canvas.strokePath();
    canvas.moveTo(cx - 115, ay + 55);
    canvas.curveTo(cx - 80, ay + 100, cx + 80, ay + 100, cx + 115, ay + 55);
    canvas.curveTo(cx + 115, ay + 30, cx - 115, ay + 30, cx - 115, ay + 55);
    canvas.strokePath();
    canvas.setLineWidth(1.5);
    for (var i = -4; i <= 4; i++) {
      canvas.moveTo(cx + i * 24.0, ay + 32);
      canvas.lineTo(cx + i * 24.0 + 4, ay + 96);
    }
    canvas.strokePath();
    canvas.setLineWidth(3.0);
    canvas.moveTo(cx, ay + 100);
    canvas.curveTo(cx + 10, ay + 130, cx + 25, ay + 165, cx + 15, ay + 185);
    canvas.strokePath();
    _drawLeaf(canvas, cx + 15, ay + 185, math.pi * 1.4, 70, 30);
    canvas.setLineWidth(1.5);
    canvas.moveTo(cx, ay - 100); canvas.lineTo(cx, ay + 55); canvas.strokePath();
    canvas.setLineWidth(3.0);
  }

  static void _drawSnowman(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    _c(canvas, cx, 155, 120); canvas.strokePath();
    canvas.setFillColor(PdfColors.white);
    _c(canvas, cx, 365, 100); canvas.fillPath();
    _c(canvas, cx, 365, 100); canvas.strokePath();
    canvas.drawRect(cx - 115, 468, 230, 16); canvas.strokePath();
    canvas.drawRect(cx - 75, 484, 150, 115); canvas.strokePath();
    canvas.setLineWidth(1.5);
    canvas.moveTo(cx - 75, 505); canvas.lineTo(cx + 75, 505); canvas.strokePath();
    canvas.setLineWidth(3.0);
    canvas.setFillColor(PdfColors.black);
    _c(canvas, cx - 30, 398, 10); canvas.fillPath();
    _c(canvas, cx + 30, 398, 10); canvas.fillPath();
    canvas.moveTo(cx, 383);
    canvas.lineTo(cx + 34, 375);
    canvas.lineTo(cx, 367);
    canvas.closePath(); canvas.strokePath();
    canvas.setLineWidth(2.0);
    for (var i = 0; i < 6; i++) {
      final a1 = -math.pi * 0.35 + i * math.pi * 0.07;
      final a2 = -math.pi * 0.35 + (i + 1) * math.pi * 0.07;
      canvas.moveTo(cx + 45 * math.cos(a1), 350 + 45 * math.sin(a1));
      canvas.lineTo(cx + 45 * math.cos(a2), 350 + 45 * math.sin(a2));
    }
    canvas.strokePath();
    canvas.setLineWidth(8.0);
    canvas.moveTo(cx - 94, 265);
    canvas.curveTo(cx - 60, 272, cx + 60, 272, cx + 94, 265);
    canvas.strokePath();
    canvas.setLineWidth(5.0);
    canvas.moveTo(cx - 88, 265); canvas.lineTo(cx - 78, 228); canvas.lineTo(cx - 90, 200);
    canvas.strokePath();
    canvas.setLineWidth(3.0);
    canvas.setFillColor(PdfColors.black);
    for (var i = 0; i < 3; i++) { _c(canvas, cx, 225.0 - i * 38, 10); canvas.fillPath(); }
    canvas.setLineWidth(4.0);
    canvas.moveTo(cx - 115, 290); canvas.lineTo(cx - 200, 335);
    canvas.moveTo(cx - 200, 335); canvas.lineTo(cx - 228, 295);
    canvas.moveTo(cx - 200, 335); canvas.lineTo(cx - 228, 365);
    canvas.moveTo(cx + 115, 290); canvas.lineTo(cx + 200, 335);
    canvas.moveTo(cx + 200, 335); canvas.lineTo(cx + 228, 295);
    canvas.moveTo(cx + 200, 335); canvas.lineTo(cx + 228, 365);
    canvas.strokePath();
    canvas.setLineWidth(2.0);
    canvas.moveTo(cx - 200, 40); canvas.lineTo(cx + 200, 40); canvas.strokePath();
    canvas.setLineWidth(3.0);
  }

  static void _drawFuji(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    canvas.moveTo(20, 120);
    canvas.curveTo(80, 122, 140, 142, cx - 80, 460);
    canvas.lineTo(cx, 580);
    canvas.lineTo(cx + 80, 460);
    canvas.curveTo(size.x - 140, 142, size.x - 80, 122, size.x - 20, 120);
    canvas.strokePath();
    canvas.moveTo(0, 120); canvas.lineTo(size.x, 120); canvas.strokePath();
    canvas.moveTo(cx - 115, 458);
    canvas.curveTo(cx - 80, 474, cx - 40, 464, cx, 469);
    canvas.curveTo(cx + 40, 464, cx + 80, 474, cx + 115, 458);
    canvas.strokePath();
    canvas.setLineWidth(1.5);
    canvas.moveTo(cx - 70, 473);
    canvas.curveTo(cx - 30, 484, cx + 30, 484, cx + 70, 473);
    canvas.strokePath();
    canvas.drawEllipse(cx, 75, 180, 33); canvas.strokePath();
    for (var i = 0; i < 3; i++) {
      canvas.moveTo(cx - 130.0 + i * 15, 60.0 + i * 10);
      canvas.curveTo(cx - 50.0 + i * 15, 54.0 + i * 10,
          cx + 50.0 + i * 15, 54.0 + i * 10, cx + 130.0 - i * 15, 60.0 + i * 10);
    }
    canvas.strokePath();
    _drawCloud(canvas, cx - 160, 530, 60, 20);
    _drawCloud(canvas, cx + 90, 505, 75, 22);
    canvas.setLineWidth(2.0);
    for (var g = 0; g < 2; g++) {
      for (var i = 0; i < 5; i++) {
        final tx = (g == 0 ? cx - 220 : cx + 100) + i * 30.0;
        canvas.moveTo(tx, 120); canvas.lineTo(tx, 138);
        canvas.moveTo(tx - 10, 138); canvas.lineTo(tx, 165); canvas.lineTo(tx + 10, 138);
        canvas.closePath(); canvas.strokePath();
      }
    }
    canvas.setLineWidth(3.0);
  }

  static void _drawCloud(PdfGraphics c, double x, double y, double w, double h) {
    _c(c, x, y, h); c.strokePath();
    _c(c, x + w * 0.38, y + h * 0.25, h * 1.2); c.strokePath();
    _c(c, x + w * 0.75, y, h); c.strokePath();
  }

  static void _drawGoldfish(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    const fy = 360.0;
    canvas.drawEllipse(cx, fy, 130, 95); canvas.strokePath();
    canvas.setFillColor(PdfColors.white);
    canvas.drawEllipse(cx + 78, fy, 68, 68); canvas.fillPath();
    canvas.drawEllipse(cx + 78, fy, 68, 68); canvas.strokePath();
    canvas.moveTo(cx + 143, fy - 5);
    canvas.curveTo(cx + 152, fy, cx + 152, fy + 8, cx + 147, fy + 12); canvas.strokePath();
    _c(canvas, cx + 104, fy + 20, 14); canvas.strokePath();
    canvas.setFillColor(PdfColors.black);
    _c(canvas, cx + 107, fy + 22, 6); canvas.fillPath();
    canvas.moveTo(cx - 125, fy);
    canvas.curveTo(cx - 178, fy + 60, cx - 218, fy + 118, cx - 188, fy + 158);
    canvas.curveTo(cx - 158, fy + 148, cx - 128, fy + 78, cx - 125, fy); canvas.strokePath();
    canvas.moveTo(cx - 125, fy);
    canvas.curveTo(cx - 178, fy - 60, cx - 218, fy - 118, cx - 188, fy - 158);
    canvas.curveTo(cx - 158, fy - 148, cx - 128, fy - 78, cx - 125, fy); canvas.strokePath();
    canvas.setLineWidth(1.5);
    for (var i = 1; i <= 3; i++) {
      canvas.moveTo(cx - 130, fy - 8 + i * 5); canvas.lineTo(cx - 198, fy + i * 55 - 25);
      canvas.moveTo(cx - 130, fy + 8 - i * 5); canvas.lineTo(cx - 198, fy - i * 55 + 25);
    }
    canvas.strokePath();
    canvas.moveTo(cx + 35, fy + 92);
    canvas.curveTo(cx - 5, fy + 148, cx - 65, fy + 138, cx - 90, fy + 78); canvas.strokePath();
    canvas.moveTo(cx + 55, fy - 28);
    canvas.curveTo(cx + 25, fy - 88, cx - 5, fy - 78, cx + 8, fy - 18); canvas.strokePath();
    canvas.setLineWidth(1.0);
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 5; col++) {
        final sx = cx - 65 + col * 38.0 + (row % 2) * 19;
        final sy = fy - 48 + row * 28.0;
        canvas.moveTo(sx - 18, sy);
        canvas.curveTo(sx - 8, sy + 14, sx + 8, sy + 14, sx + 18, sy); canvas.strokePath();
      }
    }
    canvas.setLineWidth(1.5);
    _c(canvas, cx + 148, fy + 78, 8); canvas.strokePath();
    _c(canvas, cx + 162, fy + 108, 12); canvas.strokePath();
    _c(canvas, cx + 143, fy + 132, 6); canvas.strokePath();
    canvas.setLineWidth(3.0);
  }

  static void _drawRabbit(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    canvas.drawEllipse(cx, 215, 120, 158); canvas.strokePath();
    canvas.setFillColor(PdfColors.white);
    _c(canvas, cx, 418, 85); canvas.fillPath();
    _c(canvas, cx, 418, 85); canvas.strokePath();
    canvas.drawEllipse(cx - 44, 565, 28, 88); canvas.strokePath();
    canvas.setLineWidth(1.5);
    canvas.drawEllipse(cx - 44, 565, 17, 70); canvas.strokePath();
    canvas.setLineWidth(3.0);
    canvas.drawEllipse(cx + 44, 565, 28, 88); canvas.strokePath();
    canvas.setLineWidth(1.5);
    canvas.drawEllipse(cx + 44, 565, 17, 70); canvas.strokePath();
    canvas.setLineWidth(3.0);
    _c(canvas, cx - 28, 435, 12); canvas.strokePath();
    _c(canvas, cx + 28, 435, 12); canvas.strokePath();
    canvas.setFillColor(PdfColors.black);
    _c(canvas, cx - 26, 437, 5); canvas.fillPath();
    _c(canvas, cx + 30, 437, 5); canvas.fillPath();
    canvas.moveTo(cx, 412); canvas.lineTo(cx - 10, 402); canvas.lineTo(cx + 10, 402);
    canvas.closePath(); canvas.strokePath();
    canvas.moveTo(cx, 412); canvas.curveTo(cx - 14, 403, cx - 24, 396, cx - 19, 390);
    canvas.moveTo(cx, 412); canvas.curveTo(cx + 14, 403, cx + 24, 396, cx + 19, 390);
    canvas.strokePath();
    canvas.setLineWidth(1.5);
    canvas.moveTo(cx - 14, 406); canvas.lineTo(cx - 65, 413);
    canvas.moveTo(cx - 14, 400); canvas.lineTo(cx - 65, 398);
    canvas.moveTo(cx + 14, 406); canvas.lineTo(cx + 65, 413);
    canvas.moveTo(cx + 14, 400); canvas.lineTo(cx + 65, 398);
    canvas.strokePath();
    canvas.setLineWidth(3.0);
    _c(canvas, cx + 100, 195, 24); canvas.strokePath();
    canvas.drawEllipse(cx - 55, 98, 34, 24); canvas.strokePath();
    canvas.drawEllipse(cx + 55, 98, 34, 24); canvas.strokePath();
  }

  static void _drawCat(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    canvas.drawEllipse(cx, 200, 130, 168); canvas.strokePath();
    canvas.setFillColor(PdfColors.white);
    _c(canvas, cx, 428, 100); canvas.fillPath();
    _c(canvas, cx, 428, 100); canvas.strokePath();
    canvas.moveTo(cx - 90, 493); canvas.lineTo(cx - 128, 578); canvas.lineTo(cx - 28, 543);
    canvas.closePath(); canvas.strokePath();
    canvas.setLineWidth(1.5);
    canvas.moveTo(cx - 85, 496); canvas.lineTo(cx - 108, 552); canvas.lineTo(cx - 40, 532);
    canvas.closePath(); canvas.strokePath();
    canvas.setLineWidth(3.0);
    canvas.moveTo(cx + 90, 493); canvas.lineTo(cx + 128, 578); canvas.lineTo(cx + 28, 543);
    canvas.closePath(); canvas.strokePath();
    canvas.setLineWidth(1.5);
    canvas.moveTo(cx + 85, 496); canvas.lineTo(cx + 108, 552); canvas.lineTo(cx + 40, 532);
    canvas.closePath(); canvas.strokePath();
    canvas.setLineWidth(3.0);
    canvas.drawEllipse(cx - 32, 448, 20, 16); canvas.strokePath();
    canvas.drawEllipse(cx + 32, 448, 20, 16); canvas.strokePath();
    canvas.setFillColor(PdfColors.black);
    canvas.drawEllipse(cx - 32, 448, 8, 13); canvas.fillPath();
    canvas.drawEllipse(cx + 32, 448, 8, 13); canvas.fillPath();
    canvas.moveTo(cx, 418); canvas.lineTo(cx - 12, 406); canvas.lineTo(cx + 12, 406);
    canvas.closePath(); canvas.strokePath();
    canvas.moveTo(cx, 418); canvas.curveTo(cx - 15, 408, cx - 22, 400, cx - 18, 394);
    canvas.moveTo(cx, 418); canvas.curveTo(cx + 15, 408, cx + 22, 400, cx + 18, 394);
    canvas.strokePath();
    canvas.setLineWidth(1.5);
    canvas.moveTo(cx - 15, 411); canvas.lineTo(cx - 80, 418);
    canvas.moveTo(cx - 15, 405); canvas.lineTo(cx - 80, 405);
    canvas.moveTo(cx - 15, 399); canvas.lineTo(cx - 80, 392);
    canvas.moveTo(cx + 15, 411); canvas.lineTo(cx + 80, 418);
    canvas.moveTo(cx + 15, 405); canvas.lineTo(cx + 80, 405);
    canvas.moveTo(cx + 15, 399); canvas.lineTo(cx + 80, 392);
    canvas.strokePath();
    canvas.setLineWidth(3.0);
    canvas.moveTo(cx + 118, 98);
    canvas.curveTo(cx + 198, 148, cx + 218, 278, cx + 158, 318);
    canvas.curveTo(cx + 118, 338, cx + 78, 308, cx + 98, 278); canvas.strokePath();
    canvas.drawEllipse(cx - 60, 63, 42, 26); canvas.strokePath();
    canvas.drawEllipse(cx + 60, 63, 42, 26); canvas.strokePath();
    canvas.setLineWidth(1.5);
    for (var i = -1; i <= 1; i++) {
      _c(canvas, cx - 60 + i * 14.0, 78, 8); canvas.strokePath();
      _c(canvas, cx + 60 + i * 14.0, 78, 8); canvas.strokePath();
    }
    canvas.moveTo(cx - 100, 278); canvas.curveTo(cx - 50, 273, cx + 50, 273, cx + 100, 278);
    canvas.moveTo(cx - 110, 228); canvas.curveTo(cx - 55, 223, cx + 55, 223, cx + 110, 228);
    canvas.strokePath();
    canvas.setLineWidth(3.0);
  }

  static void _drawButterfly(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    const by = 340.0;
    canvas.drawEllipse(cx, by, 14, 118); canvas.strokePath();
    _c(canvas, cx, by + 133, 20); canvas.strokePath();
    canvas.moveTo(cx - 5, by + 153);
    canvas.curveTo(cx - 28, by + 198, cx - 58, by + 228, cx - 54, by + 244); canvas.strokePath();
    _c(canvas, cx - 54, by + 248, 6); canvas.strokePath();
    canvas.moveTo(cx + 5, by + 153);
    canvas.curveTo(cx + 28, by + 198, cx + 58, by + 228, cx + 54, by + 244); canvas.strokePath();
    _c(canvas, cx + 54, by + 248, 6); canvas.strokePath();
    canvas.moveTo(cx, by + 98);
    canvas.curveTo(cx - 28, by + 158, cx - 178, by + 198, cx - 198, by + 98);
    canvas.curveTo(cx - 218, by - 2, cx - 148, by - 82, cx, by); canvas.strokePath();
    canvas.moveTo(cx, by + 98);
    canvas.curveTo(cx + 28, by + 158, cx + 178, by + 198, cx + 198, by + 98);
    canvas.curveTo(cx + 218, by - 2, cx + 148, by - 82, cx, by); canvas.strokePath();
    canvas.moveTo(cx, by);
    canvas.curveTo(cx - 78, by - 18, cx - 168, by - 58, cx - 158, by - 148);
    canvas.curveTo(cx - 128, by - 198, cx - 48, by - 158, cx, by - 118); canvas.strokePath();
    canvas.moveTo(cx, by);
    canvas.curveTo(cx + 78, by - 18, cx + 168, by - 58, cx + 158, by - 148);
    canvas.curveTo(cx + 128, by - 198, cx + 48, by - 158, cx, by - 118); canvas.strokePath();
    canvas.setLineWidth(1.5);
    _c(canvas, cx - 98, by + 98, 28); canvas.strokePath();
    _c(canvas, cx - 138, by + 58, 18); canvas.strokePath();
    _c(canvas, cx + 98, by + 98, 28); canvas.strokePath();
    _c(canvas, cx + 138, by + 58, 18); canvas.strokePath();
    _c(canvas, cx - 88, by - 78, 17); canvas.strokePath();
    _c(canvas, cx + 88, by - 78, 17); canvas.strokePath();
    canvas.moveTo(cx, by); canvas.lineTo(cx - 178, by + 98);
    canvas.moveTo(cx, by); canvas.lineTo(cx + 178, by + 98);
    canvas.moveTo(cx, by); canvas.lineTo(cx - 138, by - 128);
    canvas.moveTo(cx, by); canvas.lineTo(cx + 138, by - 128);
    canvas.strokePath();
    canvas.setLineWidth(3.0);
  }

  static void _drawDefault(PdfGraphics canvas, PdfPoint size) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.drawRect(20, 20, size.x - 40, size.y - 40); canvas.strokePath();
    for (var i = 0; i < 6; i++) {
      final a = i * math.pi / 3;
      _c(canvas, cx + 80 * math.cos(a), cy + 80 * math.sin(a), 60); canvas.strokePath();
    }
    canvas.setFillColor(PdfColors.white);
    _c(canvas, cx, cy, 55); canvas.fillPath();
    _c(canvas, cx, cy, 55); canvas.strokePath();
  }
}
