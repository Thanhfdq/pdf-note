import 'package:flutter/foundation.dart';

class PdfState extends ChangeNotifier {
  int _currentPage = 1; // Track the current page
  int _totalPages = 0; // Track total pages
  bool _isViewMode = false;

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isViewMode => _isViewMode;

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setTotalPages(int totalPages) {
    _totalPages = totalPages;
    notifyListeners();
  }

  void setMode(bool isViewMode) {
    _isViewMode = isViewMode;
  }
}
