import 'package:flutter/foundation.dart';
import 'package:pdf_note/constants/app_strings.dart';
import 'package:pdf_note/models/pen_config.dart';
import 'package:pdf_note/models/textbox_config.dart';
import 'package:pdf_note/providers/pdf_data.dart';

class PdfState with ChangeNotifier {
  int _currentPage = 1; // Track the current page
  int _totalPages = 1; // Track total pages
  bool _isViewMode = false;
  final List<PdfData> _pdfDatas = [
    PdfData()
  ]; // Default a pdf page always have 1 pdfData
  String _currentTool = AppStrings.penTool;
  PenConfig _penConfig = PenConfig();
  TextboxConfig _textboxConfig = TextboxConfig();

  String get currentTool => _currentTool;
  PenConfig get penConfig => _penConfig;
  TextboxConfig get textboxConfig => _textboxConfig;

  List<PdfData> get pdfDatas => _pdfDatas;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isViewMode => _isViewMode;

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void addPage() {
    _pdfDatas.add(PdfData());
    notifyListeners();
  }

  set removePage(int index) {
    _pdfDatas.removeAt(index);
    notifyListeners();
  }

  void setTotalPages(int totalPages) {
    _totalPages = totalPages;
    notifyListeners();
  }

  set setMode(bool isViewMode) {
    _isViewMode = isViewMode;
  }

  set currentTool(String value) {
    _currentTool = value;
    notifyListeners();
  }

  set penConfig(PenConfig value) {
    _penConfig = value;
    notifyListeners();
  }

  set textboxConfig(TextboxConfig value) {
    _textboxConfig = value;
    notifyListeners();
  }
}
