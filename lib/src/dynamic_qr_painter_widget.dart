import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:math' as math;

/// QR code module shape styles
enum QrModuleShape {
  square, // Default square modules
  dot, // Circular dots
  rounded, // Rounded corners
  diamond, // Diamond/rotated square
  heart, // Heart shape (decorative)
}

/// A widget that generates and displays a QR code using CustomPainter.
class DynamicQrPainterWidget extends StatelessWidget {
  final String data;
  final double size;
  final Color darkColor;
  final Color lightColor;
  final ImageProvider? centerImage;
  final double? centerImageSize;
  final Color centerImageBorderColor;
  final double centerImageBorderWidth;

  /// The shape style of QR code modules
  final QrModuleShape moduleShape;

  /// Gap between modules (for dot/rounded styles)
  final double moduleGap;

  const DynamicQrPainterWidget({
    super.key,
    required this.data,
    this.size = 200,
    this.darkColor = Colors.black,
    this.lightColor = Colors.white,
    this.centerImage,
    this.centerImageSize,
    this.centerImageBorderColor = Colors.white,
    this.centerImageBorderWidth = 4,
    this.moduleShape = QrModuleShape.square,
    this.moduleGap = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    if (centerImage == null) {
      return CustomPaint(
        size: Size(size, size),
        painter: _DynamicQrPainter(
          data: data,
          darkColor: darkColor,
          lightColor: lightColor,
          moduleShape: moduleShape,
          moduleGap: moduleGap,
        ),
      );
    }

    return FutureBuilder<ui.Image?>(
      key: ValueKey(centerImage.hashCode),
      future: _loadImage(centerImage!),
      builder: (context, snapshot) {
        return CustomPaint(
          size: Size(size, size),
          painter: _DynamicQrPainter(
            data: data,
            darkColor: darkColor,
            lightColor: lightColor,
            centerImage: snapshot.data,
            centerImageSize: centerImageSize ?? size * 0.2,
            centerImageBorderColor: centerImageBorderColor,
            centerImageBorderWidth: centerImageBorderWidth,
            moduleShape: moduleShape,
            moduleGap: moduleGap,
          ),
        );
      },
    );
  }

  Future<ui.Image?> _loadImage(ImageProvider provider) async {
    try {
      final completer = Completer<ui.Image>();
      final stream = provider.resolve(const ImageConfiguration());

      late ImageStreamListener listener;
      listener = ImageStreamListener(
        (ImageInfo info, bool _) {
          if (!completer.isCompleted) {
            completer.complete(info.image);
          }
          stream.removeListener(listener);
        },
        onError: (exception, stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(exception);
          }
          stream.removeListener(listener);
        },
      );

      stream.addListener(listener);
      return await completer.future;
    } catch (e) {
      debugPrint('Error loading center image: $e');
      return null;
    }
  }
}

class _DynamicQrPainter extends CustomPainter {
  final String data;
  final Color darkColor;
  final Color lightColor;
  final ui.Image? centerImage;
  final double? centerImageSize;
  final Color? centerImageBorderColor;
  final double? centerImageBorderWidth;
  final QrModuleShape moduleShape;
  final double moduleGap;

  _DynamicQrPainter({
    required this.data,
    required this.darkColor,
    required this.lightColor,
    this.centerImage,
    this.centerImageSize,
    this.centerImageBorderColor,
    this.centerImageBorderWidth,
    required this.moduleShape,
    required this.moduleGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    try {
      final qrCode = QrCode(
        4,
        centerImageSize != null && centerImageSize! > 50
            ? QrErrorCorrectLevel.Q
            : QrErrorCorrectLevel.M,
      )..addData(data);

      final qrImage = QrImage(qrCode);
      final moduleCount = qrImage.moduleCount;
      final cellSize = size.width / moduleCount;

      final paintDark = Paint()
        ..color = darkColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      final paintLight = Paint()
        ..color = lightColor
        ..style = PaintingStyle.fill;

      // Draw background
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        paintLight,
      );

      // Calculate center exclusion area
      double? centerX, centerY, centerRadius;
      if (centerImage != null && centerImageSize != null) {
        centerX = size.width / 2;
        centerY = size.height / 2;
        centerRadius = (centerImageSize! + (centerImageBorderWidth ?? 0)) / 2;
      }

      // Render QR code modules with selected shape
      for (int x = 0; x < moduleCount; x++) {
        for (int y = 0; y < moduleCount; y++) {
          if (qrImage.isDark(y, x)) {
            final moduleX = x * cellSize;
            final moduleY = y * cellSize;

            // Skip modules in center area
            if (centerX != null && centerY != null && centerRadius != null) {
              final rectCenterX = moduleX + cellSize / 2;
              final rectCenterY = moduleY + cellSize / 2;
              final dx = rectCenterX - centerX;
              final dy = rectCenterY - centerY;
              final distance = math.sqrt(dx * dx + dy * dy);

              if (distance < centerRadius) {
                continue;
              }
            }

            // Draw module based on selected shape
            _drawModule(
              canvas,
              paintDark,
              moduleX,
              moduleY,
              cellSize,
              moduleShape,
            );
          }
        }
      }

      // Draw center image
      if (centerImage != null && centerImageSize != null) {
        _drawCenterImage(canvas, size);
      }
    } catch (e) {
      _drawError(canvas, size);
    }
  }

  /// Draw individual module based on shape style
  void _drawModule(
    Canvas canvas,
    Paint paint,
    double x,
    double y,
    double size,
    QrModuleShape shape,
  ) {
    final gap = size * moduleGap;
    final adjustedSize = size - gap;
    final offset = gap / 2;

    switch (shape) {
      case QrModuleShape.square:
        canvas.drawRect(
          Rect.fromLTWH(x, y, size, size),
          paint,
        );
        break;

      case QrModuleShape.dot:
        final center = Offset(x + size / 2, y + size / 2);
        final radius = adjustedSize / 2;
        canvas.drawCircle(center, radius, paint);
        break;

      case QrModuleShape.rounded:
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x + offset, y + offset, adjustedSize, adjustedSize),
          Radius.circular(adjustedSize * 0.3),
        );
        canvas.drawRRect(rect, paint);
        break;

      case QrModuleShape.diamond:
        final path = Path()
          ..moveTo(x + size / 2, y + offset)
          ..lineTo(x + size - offset, y + size / 2)
          ..lineTo(x + size / 2, y + size - offset)
          ..lineTo(x + offset, y + size / 2)
          ..close();
        canvas.drawPath(path, paint);
        break;

      case QrModuleShape.heart:
        _drawHeart(canvas, paint, x + offset, y + offset, adjustedSize);
        break;
    }
  }

  /// Draw heart shape module
  void _drawHeart(Canvas canvas, Paint paint, double x, double y, double size) {
    final path = Path();
    final centerX = x + size / 2;
    final topY = y + size * 0.3;

    // Left curve
    path.moveTo(centerX, topY);
    path.cubicTo(
      centerX - size * 0.5,
      topY - size * 0.3,
      centerX - size * 0.5,
      topY + size * 0.2,
      centerX,
      y + size * 0.9,
    );

    // Right curve
    path.cubicTo(
      centerX + size * 0.5,
      topY + size * 0.2,
      centerX + size * 0.5,
      topY - size * 0.3,
      centerX,
      topY,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawCenterImage(Canvas canvas, Size size) {
    if (centerImage == null || centerImageSize == null) return;

    final center = Offset(size.width / 2, size.height / 2);
    final imageSize = centerImageSize!;
    final radius = imageSize / 2;

    canvas.save();

    // Draw border
    if (centerImageBorderWidth != null && centerImageBorderWidth! > 0) {
      final borderPaint = Paint()
        ..color = centerImageBorderColor ?? Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        center,
        radius + centerImageBorderWidth!,
        borderPaint,
      );
    }

    // Clip to circle
    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.clipPath(clipPath);

    // Draw image
    final srcRect = Rect.fromLTWH(
      0,
      0,
      centerImage!.width.toDouble(),
      centerImage!.height.toDouble(),
    );

    final dstRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawImageRect(centerImage!, srcRect, dstRect, Paint());

    canvas.restore();
  }

  void _drawError(Canvas canvas, Size size) {
    final errorPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      errorPaint,
    );

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

  @override
  bool shouldRepaint(_DynamicQrPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.darkColor != darkColor ||
        oldDelegate.lightColor != lightColor ||
        oldDelegate.centerImage != centerImage ||
        oldDelegate.centerImageSize != centerImageSize ||
        oldDelegate.moduleShape != moduleShape ||
        oldDelegate.moduleGap != moduleGap;
  }
}
