import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:pdf_note/constants/app_colors.dart';
import 'package:pdf_note/models/canvas_element.dart';

class CanvasPainter extends CustomPainter {
  final List<CanvasElement> canvasElements;

  CanvasPainter(this.canvasElements);

  ui.Picture? _cachedPicture;
  ui.Image? _cachedImage;

  @override
  void paint(Canvas canvas, Size size) {
    // Nếu đã cache, vẽ từ cached image
    if (_cachedImage != null) {
      paintImage(
        canvas: canvas,
        rect: Offset.zero & size,
        image: _cachedImage!,
      );
      return;
    }

    // Ghi lại các phần tử lên ui.Picture
    final recorder = ui.PictureRecorder();
    final recordedCanvas = Canvas(recorder, Offset.zero & size);
    // Xóa nền bằng màu trắng hoặc màu nền mong muốn
    // canvas.drawColor(Colors.yellow, BlendMode.src);
    // Vẽ từng phần tử
    for (var element in canvasElements) {
      if (element is InkStroke) {
        _drawInkStroke(recordedCanvas, element);
      } else if (element is EraserStroke) {
        _drawEraseStroke(recordedCanvas, element);
      } else if (element is TextBox) {
        _drawTextbox(recordedCanvas, element);
      } else if (element is InsertImage) {
        _drawImage(recordedCanvas, element);
      }
    }

    // Lưu lại Picture và Image
    _cachedPicture = recorder.endRecording();
    _cachedPicture!
        .toImage(size.width.toInt(), size.height.toInt())
        .then((image) {
      _cachedImage = image;
    });

    // Vẽ picture lên canvas
    canvas.drawPicture(_cachedPicture!);
  }

  // Draw the given ink stroke on canvas
  void _drawInkStroke(Canvas canvas, InkStroke inkStroke) {
    // Prepare the paint to draw
    final inkPaint = Paint()
      ..color = inkStroke.inkColor
      ..strokeWidth = inkStroke.strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < inkStroke.inkDots.length - 1; i++) {
      canvas.drawLine(inkStroke.inkDots[i], inkStroke.inkDots[i + 1], inkPaint);
    }
  }

  // Draw the given erase stroke on canvas
  void _drawEraseStroke(Canvas canvas, EraserStroke eraseStroke) {
    final eraserPaint = Paint()
      // ..blendMode = BlendMode.clear
      ..color = AppColors.defaultBackground
      ..strokeWidth = eraseStroke.strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < eraseStroke.eraserDots.length - 1; i++) {
      canvas.drawLine(eraseStroke.eraserDots[i], eraseStroke.eraserDots[i + 1],
          eraserPaint);
    }
  }

  // Draw the given textbox on canvas
  void _drawTextbox(Canvas canvas, TextBox textbox) {
    final textboxPainter = TextPainter(
      text: TextSpan(
        text: textbox.content,
        style: TextStyle(
          color: textbox.textColor,
          fontSize: textbox.fontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textboxPainter.layout();
    textboxPainter.paint(canvas, textbox.position);
  }

  // Draw the given image on canvas
  void _drawImage(Canvas canvas, InsertImage element) {
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(
        element.position.dx,
        element.position.dy,
        element.size.width,
        element.size.height,
      ),
      image: element.uiImage,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  // Hàm để xóa cache (nếu cần khởi tạo lại)
  void clearCache() {
    _cachedPicture = null;
    _cachedImage = null;
  }
}
