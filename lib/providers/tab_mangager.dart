import 'package:flutter/foundation.dart';
import 'package:pdf_note/providers/markdown_state.dart';
import 'tab_state.dart'; // Assuming the TabState is in a separate file

class TabsManager with ChangeNotifier {
  final List<TabState> _tabs = [
    TabState.withMarkdown(
        mode: "new", fileName: "", markdownState: MarkdownState())
  ];

  List<TabState> get tabs => List.unmodifiable(_tabs);
  int currentTab = 0;

  void setCurrentTab(int index) {
    currentTab = index;
    notifyListeners();
  }

  void addTab(String mode, String fileName) {
    _tabs.add(TabState(
      mode: mode,
      fileName: fileName,
    ));
    notifyListeners();
  }

  void removeTab(int index) {
    _tabs.removeAt(index);
    notifyListeners();
  }

  void updateTab(int index,
      {String? mode, String? fileName, String? markdownContent}) {
    if (index < 0 || index >= _tabs.length) return;
    if (mode != null) _tabs[index].setMode(mode);
    if (fileName != null) _tabs[index].setFileName(fileName);
    if (markdownContent != null) {
      _tabs[index].markdownState?.setContent(markdownContent);
    }
    notifyListeners();
  }

  void toggleViewMarkdownMode(int index) {
    _tabs[index].markdownState?.toggleView();
    notifyListeners();
  }
}
