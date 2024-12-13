import 'dart:ui';

abstract class CanvasElement {
  Offset position;
  double? rotation;

  CanvasElement(this.position, this.rotation);

  bool constainsPoint(Offset point);
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

  @override
  bool constainsPoint(Offset point) {
    // TODO: implement constainsPoint
    throw UnimplementedError();
  }
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

  @override
  bool constainsPoint(Offset point) {
    // Assume the text box has a width and height based on text layout
    final textWidth = content.length * fontSize * 0.5; // Approximation
    final textHeight = fontSize; // Single-line height

    final rect = Rect.fromLTWH(position.dx, position.dy, textWidth, textHeight);
    return rect.contains(point);
  }
}

class InsertImage extends CanvasElement {
  String imagePath;
  Image uiImage;
  Size size;

  InsertImage({
    required Offset position,
    required this.imagePath,
    required this.size,
    required this.uiImage,
    double rotation = 0,
  }) : super(position, rotation);

  @override
  bool constainsPoint(Offset point) {
    final rect =
        Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
    return rect.contains(point);
  }
}

class EraserStroke extends CanvasElement {
  List<Offset> eraserDots;
  double strokeWidth;

  EraserStroke(
      {required this.eraserDots,
      required Offset position,
      required this.strokeWidth})
      : super(position, 0.0);

  @override
  bool constainsPoint(Offset point) {
    // TODO: implement constainsPoint
    throw UnimplementedError();
  }
}
