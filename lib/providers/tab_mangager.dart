import 'package:flutter/foundation.dart';
import 'package:pdf_note/providers/markdown_state.dart';
import 'tab_state.dart'; // Assuming the TabState is in a separate file

class TabsManager with ChangeNotifier {
  final List<TabState> _tabs = [
    TabState.withMarkdown(
        mode: "new", filePath: "", markdownState: MarkdownState())
  ];

  List<TabState> get tabs => List.unmodifiable(_tabs);
  int currentTab = 0;
  bool _isOptionsOpen = false;
  bool get isOptionsOpen => _isOptionsOpen;

  void setCurrentTab(int index) {
    currentTab = index;
    notifyListeners();
  }

  void addTab(String mode, String fileName) {
    _tabs.add(TabState(
      mode: mode,
      filePath: fileName,
    ));
    notifyListeners();
  }

  void removeTab(int index) {
    _tabs.removeAt(index);
    notifyListeners();
  }

  void updateTab(int index,
      {String? mode,
      String? filePath,
      MarkdownState? markdownState,
      String? markdownContent}) {
    if (index < 0 || index >= _tabs.length) return;
    if (mode != null) _tabs[index].setMode(mode);
    if (filePath != null) _tabs[index].setFileName(filePath);
    if (markdownState != null) _tabs[index].setMarkdownState(markdownState);
    if (markdownContent != null) {
      _tabs[index].markdownState?.setContent(markdownContent);
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
    print("Change option status $_isOptionsOpen");
    notifyListeners();
  }
}
