import 'dart:ui';

import 'package:pdf_note/constants/app_colors.dart';
import 'package:pdf_note/constants/app_numbers.dart';

class PenConfig {
  Color _color = AppColors.defaultPenColor;
  double _strokeWidth = AppNumbers.defaultStrokeWidth;

  Color get color => _color;
  double get strokewidth => _strokeWidth;

  void setColor(Color color) {
    _color = color;
  }

  void setStrokeWidth(double strokeWidth) {
    _strokeWidth = strokeWidth;
  }
}
