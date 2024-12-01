import 'package:flutter/foundation.dart';

class PdfState extends ChangeNotifier {
  int _currentPage = 1; // Track the current page
  int _totalPages = 0; // Track total pages

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setTotalPages(int totalPages) {
    _totalPages = totalPages;
    notifyListeners();
  }
}
