import 'dart:ui';

abstract class CanvasElement {
  Offset position;
  double? rotation;

  CanvasElement(this.position, this.rotation);
}

class InkStroke extends CanvasElement {
  List<Offset> inkDots;
  double strokeWidth;
  Color inkColor;

  InkStroke(
      {required Offset position,
      required this.inkColor,
      double rotation = 0.0,
      required this.inkDots,
      required this.strokeWidth})
      : super(position, rotation);
}

class TextBox extends CanvasElement {
  String content;
  double fontSize;
  Color textColor;

  TextBox({
    required Offset position,
    required this.content,
    required this.fontSize,
    required this.textColor,
    double rotation = 0,
  }) : super(position, rotation);
}

class InsertImage extends CanvasElement {
  String imagePath;
  Size size;

  InsertImage({
    required Offset position,
    required this.imagePath,
    required this.size,
    double rotation = 0,
  }) : super(position, rotation);
}

class EraserStroke extends CanvasElement {
  List<Offset> eraserDots;
  double strokeWidth;

  EraserStroke(
      {required this.eraserDots,
      required Offset position,
      required this.strokeWidth})
      : super(position, 0.0);
}
