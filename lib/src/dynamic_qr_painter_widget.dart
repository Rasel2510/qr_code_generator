import 'package:flutter/material.dart';
import 'package:qr/qr.dart';

/// A widget that generates and displays a QR code using CustomPainter.
///
/// This widget creates a QR code from the provided [data] string and renders
/// it with customizable colors and size.
///
/// Example:
/// ```dart
/// DynamicQrPainterWidget(
///   data: 'https://example.com',
///   size: 200,
///   darkColor: Colors.black,
///   lightColor: Colors.white,
/// )
/// ```
class DynamicQrPainterWidget extends StatelessWidget {
  /// The data to encode in the QR code.
  final String data;

  /// The size of the QR code widget (width and height).
  final double size;

  /// The color used for dark modules (typically black).
  final Color darkColor;

  /// The color used for light modules/background (typically white).
  final Color lightColor;

  /// Creates a QR code widget.
  ///
  /// The [data] parameter is required and contains the information to encode.
  /// The [size] defaults to 200.
  /// The [darkColor] defaults to black.
  /// The [lightColor] defaults to white.
  const DynamicQrPainterWidget({
    super.key,
    required this.data,
    this.size = 200,
    this.darkColor = Colors.black,
    this.lightColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DynamicQrPainter(
        data: data,
        darkColor: darkColor,
        lightColor: lightColor,
      ),
    );
  }
}

/// Internal painter class that renders the QR code on a canvas.
class _DynamicQrPainter extends CustomPainter {
  final String data;
  final Color darkColor;
  final Color lightColor;

  _DynamicQrPainter({
    required this.data,
    required this.darkColor,
    required this.lightColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    try {
      // Generate QR code with version 4 and low error correction
      final qrCode = QrCode(4, QrErrorCorrectLevel.L)..addData(data);

      // Create QrImage from QrCode
      final qrImage = QrImage(qrCode);

      final moduleCount = qrImage.moduleCount;
      final cellSize = size.width / moduleCount;

      final paintDark = Paint()
        ..color = darkColor
        ..style = PaintingStyle.fill;

      final paintLight = Paint()
        ..color = lightColor
        ..style = PaintingStyle.fill;

      // Draw background
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        paintLight,
      );

      // Render QR code modules
      for (int x = 0; x < moduleCount; x++) {
        for (int y = 0; y < moduleCount; y++) {
          if (qrImage.isDark(y, x)) {
            canvas.drawRect(
              Rect.fromLTWH(
                x * cellSize,
                y * cellSize,
                cellSize,
                cellSize,
              ),
              paintDark,
            );
          }
        }
      }
    } catch (e) {
      // If QR generation fails, draw error indicator
      final errorPaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        errorPaint,
      );

      // Draw X
      canvas.drawLine(
        const Offset(0, 0),
        Offset(size.width, size.height),
        errorPaint,
      );
      canvas.drawLine(
        Offset(size.width, 0),
        Offset(0, size.height),
        errorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_DynamicQrPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.darkColor != darkColor ||
        oldDelegate.lightColor != lightColor;
  }
}
