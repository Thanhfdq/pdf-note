import 'package:flutter/foundation.dart';
import 'package:pdf_note/constants/app_strings.dart';
import 'package:pdf_note/models/eraser_config.dart';
import 'package:pdf_note/models/pen_config.dart';
import 'package:pdf_note/models/textbox_config.dart';
import 'package:pdf_note/providers/canvas_state.dart';

class PdfState with ChangeNotifier {
  // List data of each page, a CanvasState is an page's data
  List<CanvasState> _canvasStates = [
    CanvasState()
  ]; // Default a pdf page always have 1 pdfData
  int _currentPage = 1; // Track the current page
  int _totalPages = 1; // Track total pages
  bool _isViewMode = false; // Track the mode is view pdf or editting
  String _currentTool = AppStrings.penTool; // Save the current using tool
  PenConfig _penConfig = PenConfig(); // current pen configurations
  TextboxConfig _textboxConfig =
      TextboxConfig(); // current textbox configurations
  EraserConfig _eraserConfig = EraserConfig(); // current eraser configurations

  // Getters & Setter
  // pdf's data
  List<CanvasState> get canvasStates => _canvasStates;
  set canvasStates(List<CanvasState> value) {
    _canvasStates = value;
    notifyListeners();
  }

  void addPage() {
    _canvasStates.add(CanvasState());
    notifyListeners();
  }

  set removePage(int index) {
    _canvasStates.removeAt(index);
    notifyListeners();
  }

  // current page
  int get currentPage => _currentPage;
  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  // total page
  int get totalPages => _totalPages;
  set totalPages(int value) {
    _totalPages = value;
    notifyListeners();
  }

  // is view mode
  bool get isViewMode => _isViewMode;
  set isViewMode(bool value) {
    _isViewMode = value;
    notifyListeners();
  }

  // current tool
  String get currentTool => _currentTool;
  set currentTool(String value) {
    _currentTool = value;
    notifyListeners();
  }

  // pen config
  PenConfig get penConfig => _penConfig;
  set penConfig(PenConfig value) {
    _penConfig = value;
    notifyListeners();
  }

  // text config
  TextboxConfig get textboxConfig => _textboxConfig;
  set textboxConfig(TextboxConfig value) {
    _textboxConfig = value;
    notifyListeners();
  }

  //eraser config
  EraserConfig get eraserConfig => _eraserConfig;
  set eraserConfig(EraserConfig value) {
    _eraserConfig = value;
    notifyListeners();
  }
}
