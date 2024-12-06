import 'package:flutter/foundation.dart';
import 'package:pdf_note/constants/app_strings.dart';
import 'package:pdf_note/providers/markdown_state.dart';
import 'package:pdf_note/providers/pdf_state.dart';
import 'tab_state.dart'; // Assuming the TabState is in a separate file

class TabsManager with ChangeNotifier {
  final List<TabState> _tabs = [
    TabState(mode: AppStrings.newTabMode, filePath: "")
    // TabState.withPdf(
    //     mode: AppStrings.pdfMode, filePath: "", pdfState: PdfState())
  ];

  List<TabState> get tabs => List.unmodifiable(_tabs);
  int currentTab = 0;
  String defaultFileLocation = "";
  bool _isTabWindowOpen = false;
  bool _isOptionsWindowOpen = false;
  bool get isOptionsOpen => _isOptionsWindowOpen;
  bool get isTabWindowOpen => _isTabWindowOpen;

  void setCurrentTab(int index) {
    currentTab = index;
    notifyListeners();
  }

  void addTab(String mode, String filePath) {
    _tabs.add(TabState(
      mode: mode,
      filePath: filePath,
    ));
    notifyListeners();
  }

  void removeTab(int index) {
    _tabs.removeAt(index);
    notifyListeners();
  }

  void removeAllTab() {
    _tabs.clear();
    notifyListeners();
  }

  void updateTab(int index,
      {String? newMode,
      String? newFilePath,
      MarkdownState? newMarkDownState,
      String? newMarkdownContent,
      PdfState? newPdfState}) {
    if (index < 0 || index >= _tabs.length) return;
    if (newMode != null) _tabs[index].setMode(newMode);
    if (newFilePath != null) _tabs[index].setFilePath(newFilePath);
    if (newMarkDownState != null) {
      _tabs[index].setMarkdownState(newMarkDownState);
    }
    if (newMarkdownContent != null) {
      _tabs[index].markdownState?.setContent(newMarkdownContent);
    }
    if (newPdfState != null) _tabs[index].setPdfState(newPdfState);
    notifyListeners();
  }

  void toggleViewMarkdownMode(int index) {
    _tabs[index].markdownState?.toggleView();
    notifyListeners();
  }

  bool undoOfMarkdown() {
    bool isSuccess = _tabs[currentTab].markdownState!.undo();
    notifyListeners();
    return isSuccess;
  }

  bool redoOfMarkdown() {
    bool isSuccess = _tabs[currentTab].markdownState!.redo();
    notifyListeners();
    return isSuccess;
  }

  void toggleTabWindow() {
    _isTabWindowOpen = !_isTabWindowOpen;
    notifyListeners();
  }

  void toggleOption() {
    _isOptionsWindowOpen = !_isOptionsWindowOpen;
    notifyListeners();
  }
}
