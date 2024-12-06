import 'package:pdf_note/constants/app_numbers.dart';

class EraserConfig {
  double _eraseStrokeWidth = AppNumbers.defaultEraserwidth;
  double get eraseStrokeWidth => _eraseStrokeWidth;

  void setSize(double eraseStroke) {
    _eraseStrokeWidth = eraseStroke;
  }
}
