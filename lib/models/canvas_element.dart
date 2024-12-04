import 'dart:ui';

abstract class CanvasElement {
  Offset position;
  double rotation;
  Color color;

  CanvasElement(this.position, this.rotation, this.color);
}

class DrawingElement extends CanvasElement {
  List<Offset> points;
  double strokeWidth;

  DrawingElement(
      {required Offset position,
      required Color color,
      double rotation = 0.0,
      required this.points,
      required this.strokeWidth})
      : super(position, rotation, color);
}

class TextElement extends CanvasElement {
  String text;
  double fontSize;

  TextElement({
    required Offset position,
    required this.text,
    required this.fontSize,
    required Color color,
    double rotation = 0,
  }) : super(position, rotation, color);
}

class ImageElement extends CanvasElement {
  String imagePath;
  Size size;

  ImageElement({
    required Offset position,
    required this.imagePath,
    required this.size,
    double rotation = 0,
  }) : super(position, rotation, const Color(0x00000000));
}
