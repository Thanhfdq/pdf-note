import 'package:flutter/foundation.dart';
import 'package:pdf_note/providers/markdown_state.dart';
import 'package:pdf_note/providers/pdf_state.dart';
import 'tab_state.dart'; // Assuming the TabState is in a separate file

class TabsManager with ChangeNotifier {
  final List<TabState> _tabs = [
    TabState(mode: "new", filePath: ""),
    TabState.withPdf(mode: "pdf", filePath: "", pdfState: PdfState())
  ];

  List<TabState> get tabs => List.unmodifiable(_tabs);
  int currentTab = 1;
  bool _isOptionsOpen = false;
  bool get isOptionsOpen => _isOptionsOpen;

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
      String? newMarkdownContent}) {
    if (index < 0 || index >= _tabs.length) return;
    if (newMode != null) _tabs[index].setMode(newMode);
    if (newFilePath != null) _tabs[index].setFilePath(newFilePath);
    if (newMarkDownState != null)
      _tabs[index].setMarkdownState(newMarkDownState);
    if (newMarkdownContent != null) {
      _tabs[index].markdownState?.setContent(newMarkdownContent);
    }
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

  void toggleOption() {
    _isOptionsOpen = !_isOptionsOpen;
    notifyListeners();
  }
}
