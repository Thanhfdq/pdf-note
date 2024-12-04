import 'package:flutter/material.dart';
import 'package:pdf_note/constants/app_colors.dart';
import 'package:pdf_note/constants/app_numbers.dart';
import 'package:pdf_note/models/canvas_element.dart';

class PdfData extends ChangeNotifier {
  final List<CanvasElement> _canvasElements = [];

  // Getter
  List<CanvasElement> get canvasElements => _canvasElements;

  void addDrawing(Offset position, List<Offset> points, Color? color,
      double? strokeWidth, double? rotation) {
    print("Drawing...");
    _canvasElements.add(DrawingElement(
        position: position,
        points: points,
        color: color ?? AppColors.defaultColorPen,
        strokeWidth: strokeWidth ?? AppNumbers.defaultStrokeWidth,
        rotation: rotation ?? 0));
    notifyListeners();
  }

  void addPoint(int drawingIndex, Offset point) {
    (_canvasElements[drawingIndex] as DrawingElement).points.add(point);
  }

  void addTextBox(Offset position, String text, double? fontSize, Color? color,
      double? rotation) {
    _canvasElements.add(TextElement(
        position: position,
        text: text,
        fontSize: fontSize ?? AppNumbers.defaultFontSize,
        color: color ?? AppColors.defaultTextColor));
    notifyListeners();
  }

  void addImage(
      Offset position, String imagePath, Size size, double? rotation) {
    _canvasElements.add(ImageElement(
        position: position,
        rotation: rotation ?? 0,
        imagePath: imagePath,
        size: size));
    notifyListeners();
  }
}
