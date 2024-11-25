import 'package:flutter/foundation.dart';
import 'package:pdf_note/providers/markdown_state.dart';

class TabState extends ChangeNotifier {
  String mode = "new";
  String fileName = "";
  MarkdownState? markdownState;

  TabState({required this.mode, required this.fileName});

  

  TabState.withMarkdown(
      {required this.mode,
      required this.fileName,
      required this.markdownState});

  void setMode(String mode) {
    this.mode = mode;
    notifyListeners();
  }

  void setFileName(String fileName) {
    this.fileName = fileName;
    notifyListeners();
  }
}
