import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:pdf_note/constants/app_colors.dart';
import 'package:pdf_note/constants/app_numbers.dart';
import 'package:pdf_note/models/canvas_element.dart';

class CanvasState extends ChangeNotifier {
  final List<CanvasElement> _canvasElements = [];
  Color _backgroundColor = AppColors.defaultBackground;

  // Setter
  set backgroundColor(Color value) {
    _backgroundColor = value;
    notifyListeners();
  }

  // Getter
  List<CanvasElement> get canvasElements => _canvasElements;
  Color get backgroundColor => _backgroundColor;

  // Add a drawing stroke
  void addInkStroke(Offset position, List<Offset> inkDots, Color? inkColor,
      double? strokeWidth, double? rotation) {
    print("Add an ink stroke...");
    _canvasElements.add(InkStroke(
        position: position,
        inkDots: inkDots,
        inkColor: inkColor ?? AppColors.defaultPenColor,
        strokeWidth: strokeWidth ?? AppNumbers.defaultStrokeWidth,
        rotation: rotation ?? 0));
    notifyListeners();
  }

  // Add an erase stroke
  void addEraser(
      Offset position, List<Offset> points, double eraseStrokeWidth) {
    print("Add an erase stroke...");
    _canvasElements.add(EraserStroke(
      eraserDots: points,
      position: position,
      strokeWidth: eraseStrokeWidth,
    ));
  }

  // Add a textbox
  void addTextBox(Offset position, String content, double? fontSize,
      Color? textColor, double? rotation) {
    print("Add a text box...");
    _canvasElements.add(TextBox(
        position: position,
        content: content,
        fontSize: fontSize ?? AppNumbers.defaultFontSize,
        textColor: textColor ?? AppColors.defaultTextColor));
    notifyListeners();
  }

  // Add an image
  void addImage(Offset position, String imagePath, Size size, ui.Image uiImage,
      double? rotation) {
    print("Add an image...");
    _canvasElements.add(InsertImage(
        position: position,
        rotation: rotation ?? 0,
        imagePath: imagePath,
        uiImage: uiImage,
        size: size));
    notifyListeners();
  }
}
