import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pdf_note/utils/file_helper.dart';
import 'package:flutter/material.dart';
import 'package:pdf_note/models/canvas_element.dart';

class CanvasPainter extends CustomPainter {
  final List<CanvasElement> elements;

  CanvasPainter(this.elements);

  @override
  void paint(Canvas canvas, Size size) {
    for (var element in elements) {
      if (element is DrawingElement) {
        _drawPath(canvas, element);
      } else if (element is TextElement) {
        _drawText(canvas, element);
      } else if (element is ImageElement) {
        _drawImage(canvas, element);
      }
    }
  }

  void _drawPath(Canvas canvas, DrawingElement element) {
    final paint = Paint()
      ..color = element.color
      ..strokeWidth = element.strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(element.points.first.dx, element.points.first.dy);
    for (var point in element.points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, paint);
  }

  void _drawText(Canvas canvas, TextElement element) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: element.text,
        style: TextStyle(
          color: element.color,
          fontSize: element.fontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, element.position);
  }

  void _drawImage(Canvas canvas, ImageElement element) async {
    // Get image from imagePath of element and convert to image in PaintImage
    Uint8List byteData = await FileHelper.getAssetImageBytes(element.imagePath);
    final ui.Image image = await decodeImageFromList(byteData);

    // Paint image
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(
        element.position.dx,
        element.position.dy,
        element.size.width,
        element.size.height,
      ),
      image: image,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  // Convert List<Offset> to Path (for optimize render performance)
  Path createPathFromOffsets(List<Offset> points) {
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }
    return path;
  }
}
