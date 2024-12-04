import 'dart:ui';

import 'package:pdf_note/constants/app_colors.dart';

class TextboxConfig {
  Color _color = AppColors.defaultTextColor;

  Color get color => _color;

  void setColor(Color color) {
    _color = color;
  }
}
