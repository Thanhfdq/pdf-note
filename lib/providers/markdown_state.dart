import 'package:flutter/foundation.dart';

class MarkdownState extends ChangeNotifier {
  // final VoidCallback? onNotifyParent;

  // MarkdownState({this.onNotifyParent});
  
  bool previewMode = false;
  List<String> markDownHistory = [];
  String content = "";

  void setPreviewMode(bool previewMode) {
    this.previewMode = previewMode;
    notifyListeners();
    // onNotifyParent?.call(); // Notify the parent (TabsManager)
  }

  void toggleView(){
    setPreviewMode(!previewMode);  
    notifyListeners();
  }

  void newHistory(String newContent) {
    markDownHistory.add(newContent);
    notifyListeners();
  }

  void setContent(String content){
    this.content = content;
    notifyListeners();
  }
}
